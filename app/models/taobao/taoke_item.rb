class Taobao::TaokeItem

  include Taobao::Util
  include ActionView::Helpers::SanitizeHelper

  BASIC_PROPERTIES = [:num_iid, :title, :nick, :pic_url, :price, :click_url, :commission, :commission_rate, :commission_num, :commission_volume, :shop_click_url, :seller_credit_score, :item_location, :volume]


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
    Taobao::Shop.new @nick
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
    @title = strip_tags(@title)
  end
end
