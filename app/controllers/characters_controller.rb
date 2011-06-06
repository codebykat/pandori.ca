class CharactersController < ApplicationController
  def index
    @characters = Character.all(:order => :name)
  end

  def show
    @character = Character.find(params[:id])
    @random_quote = @character.quotes.find(:first, :offset => rand(@character.quotes.count))
  end

  def update
    @character = Character.find(params[:id])

    #params[:character][:character_images].each do |image|
    #  img = CharacterImage.create!(image[1])
    #  @character.character_images << img
    #end
    #@character.save!

    #if @character.save!
    #  flash[:notice] = "successfully updated images"
    #end

    if @character.update_attributes(params[:character])
      flash[:notice] = "successfully updated character."
    #else
    #render :action => 'edit'
    end
  end
end
