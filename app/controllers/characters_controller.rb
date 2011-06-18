class CharactersController < ApplicationController
  def index
    @characters = Character.all(:order => :name)
  end

  def show
    @character = Character.find(params[:id])
    @random_quote = @character.quotes.find(:first, :offset => rand(@character.quotes.count))
    @character.character_images.build
  end

  def update
    @character = Character.find(params[:id])

    @character.update_attributes(params[:character])
    if @character.save!
      flash[:notice] = "successfully updated character."
    end

    if params[:photos_to_delete]
      params[:photos_to_delete].keys.each do |id|
        @character.character_images.find(id).destroy
      end
    end

    redirect_to :action => 'show'
  end
end
