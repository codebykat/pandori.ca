class QuotesController < ApplicationController
  def index
    @quotes = Quote.all
  end

  def random
    @quotes = []
    @images = []

    if params[:quotes]
      ids =  params[:quotes].split('.')
      ids.each do |id|
        quote_id, image_id = id.split('-')
        quote = Quote.find(quote_id)
        @quotes << quote
        
        if image_id
          @images << CharacterImage.find(image_id)
        else
          @images << quote.character.random_image
        end
      end
                              
    else
      count = Quote.count
      4.times do
        q = Quote.find(:first, :offset => rand(count))
        @quotes << q
        @images << q.character.random_image
      end
    end
  end

  def show
  end
end
