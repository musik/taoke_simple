class HomeController < ApplicationController
  def index
    @words = Word.published.recent.page(params[:page]).per(100)
  end
end
