class AdController < ApplicationController
  def index
    @q = params[:q]
  end
  def show
    @id = params[:id] || "preview"
    @q = params[:q]
    @ic = params[:ic]
    if @ic.present?
      @q.encode!('utf-8',@ic)
    end
    respond_to do |format|
      format.js
    end
  end

  def display
    @q = params[:q]
    @ic = params[:ic]
    if @ic.present?
      @q.encode!('utf-8',@ic)
    end
    @items = Taobao::TaokeItemList.search(@q,:page_size=>10,:outer_code=>'63qu').fields('title,pic_url,click_url,promotion_price,nick').order_by('commissionVolume_desc')
    render :layout=>'js'
  end
  def preview
  end
end
