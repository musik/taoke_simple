class HomeController < ApplicationController
  caches_page :index
  def index
  end
  def status
    @data = {
      :items => Item.count,
      :shops => Shop.count,
      :words => Word.count
    }
    render :json=>@data
  end
end
