class HomeController < ApplicationController
  def index
    @words = Word.published.page(params[:page]).per(100)
  end
end
