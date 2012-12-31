class HomeController < ApplicationController
  caches_page :index
  def index
    @words = Word.published.page(params[:page]).per(100)
  end
end
