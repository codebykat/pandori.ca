namespace :pandorica do
  desc 'load transcripts into the database'
  task :load => :environment do

    directory = Rails.root + Rails.application.config.transcript_directory

    unless File.directory?(directory)
      puts "Error: #{directory} not a directory."
      return
    end

    Dir.foreach(directory) do |file|
      unless file == "." || file == ".."
        fp = File.open(directory+file)
        name = fp.first.slice(2..-1).chomp

        ep = Episode.find_by_name(name)
        unless ep.nil?
          ep.delete
        end
        
        ep = Episode.new()
        ep.name = name
        ep.save!

        fp.each do |line|
          next if(line.squeeze(" ") == "")
          if(line[0] == '#')
            if(line.match(/airdate/i))
              airdate = Date.strptime(line.split(':',2)[1].strip, "%m/%d/%Y")
              ep.airdate = airdate
            elsif(line.match(/source/i))
              ep.source = line.split(':', 2)[1].strip
            else
              next
            end
          else
            unless line.index(':').nil?
              char, quote = line.split(':', 2)
              char = char.strip.chomp.titleize
              quote = quote.strip.chomp

              # kill evil unicode characters
              chars = quote.unpack("U*")
              if chars.include?(160)
                chars.delete(160)
                quote = chars.pack("U*")
              end

              if quote.blank? or char.blank?
                puts line
              else
                character = Character.find_or_create_by_name(char)
                character.save!

                ep.characters << character unless ep.characters.include?(character)

                quote = Quote.new(:text => quote,
                                  :character_id => character.id,
                                  :episode_id => ep.id)
                quote.save!
              end
            end
          end
          ep.save!
        end
      end
    end

  end
end
