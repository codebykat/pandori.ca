namespace :pandorica do
  desc 'strip unicode line endings'
  task :fix_unicode => :environment do

    Quote.all.each do |quote|
      unpacked = quote.text.unpack("U*")
      if unpacked.include?(160)
        unpacked.delete(160)
        quote.text = unpacked.pack("U*")
        quote.save!
      end
    end

  end
end
