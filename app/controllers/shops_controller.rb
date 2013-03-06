class ShopsController < ApplicationController
  def recent
  end

  def top
  end

  def show
    @shop = Shop.find_by_sid(params[:id].to_i(36))
  end
  def link
    @shop = Shop.find_by_sid(params[:id].to_i(36))
    redirect_to @shop.click_url
  end
end
