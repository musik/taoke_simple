class Taobao::TaokeItem

  include Taobao::Util
  include ActionView::Helpers::SanitizeHelper

  BASIC_PROPERTIES = [:num_iid, :title, :nick, :pic_url, :price, :click_url, :commission, :commission_rate, :commission_num, :commission_volume, :shop_click_url, :seller_credit_score, :item_location, :volume, :promotion_price]


  attr_reader *BASIC_PROPERTIES
  alias :id :num_iid

  def initialize(item_properties)
    if Hash === item_properties
      to_object item_properties
      @all_properties_fetched = false
      convert_types
    end
  end

  def shop
    Taobao::Shop.new :nick=>@nick,:click_url=>@shop_click_url
  end

  def method_missing(method_name, *args, &block)
    if instance_variable_defined? "@#{method_name}"
      self.instance_variable_get "@#{method_name}"
    else
      super
    end
  end

  private

  def convert_types
    @price = @price.to_f
    @promotion_price = @promotion_price.to_f
    #%w(commission commission_num commission_rate commission_volume).each do |k|

    #end
    @commission = @commission.to_f
    @commission_num = @commission_num.to_f
    @commission_rate = @commission_rate.to_f
    @commission_volume = @commission_volume.to_f
    @title = strip_tags(@title)
  end
end
