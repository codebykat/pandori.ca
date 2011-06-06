class QuotesController < ApplicationController
  def index
    @quotes = Quote.all
  end

  def random
    @quotes = []

    if params[:quotes]
      ids =  params[:quotes].split(".")
      ids.each do |id|
        @quotes << Quote.find(id)
      end
    
    else
      count = Quote.count
      @quotes << Quote.find(:first, :offset => rand(count))
      @quotes << Quote.find(:first, :offset => rand(count))
      @quotes << Quote.find(:first, :offset => rand(count))
      @quotes << Quote.find(:first, :offset => rand(count))
    end
  end

  def show
  end
end
