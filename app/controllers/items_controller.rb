class ItemsController < ApplicationController
  def show
    @item = Item.find params[:id]
  end
  def link
    @item = Item.find params[:id]
    redirect_to @item.click_url
  end
  def recent
    @items = Item.page(params[:page] || 1).per(40)
  end

  def hot
  end
end
