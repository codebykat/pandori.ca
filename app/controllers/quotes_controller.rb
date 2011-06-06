class QuotesController < ApplicationController
  def index
    @quotes = Quote.all
  end

  def show
  end
end
