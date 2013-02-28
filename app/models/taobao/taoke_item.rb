class Taobao::TaokeItem

  include Taobao::Util

  #BASIC_PROPERTIES = [:cid, :num_iid, :title, :nick, :price, :pic_url, :type,
    #:score, :delist_time, :post_fee, :volume]
  #OTHER_PROPERTIES = [:detail_url, :seller_cids, :props, :input_pids,
    #:input_str, :desc, :num, :valid_thru, :list_time, :stuff_status,
    #:location, :express_fee, :ems_fee, :has_discount, :freight_payer,
    #:has_invoice, :has_warranty, :has_showcase, :modified, :increment,
    #:approve_status, :postage_id, :product_id, :auction_point,
    #:property_alias, :item_img, :prop_img, :sku, :video, :outer_id,
    #:is_virtual, :sell_promise, :second_kill, :auto_fill, :props_name]
  BASIC_PROPERTIES = [:num_iid, :title, :nick, :pic_url, :price, :click_url, :commission, :commission_rate, :commission_num, :commission_volume, :shop_click_url, :seller_credit_score, :item_location, :volume]


  attr_reader *BASIC_PROPERTIES
  alias :id :num_iid

  def initialize(item_properties)
    if Hash === item_properties
      to_object item_properties
      @all_properties_fetched = false
      convert_types
    else
      @num_iid = item_properties.to_s
      fetch_full_data
    end
  end

  def user
    Taobao::User.new @nick
  end

  def method_missing(method_name, *args, &block)
    if instance_variable_defined? "@#{method_name}"
      fetch_full_data unless @all_properties_fetched
      self.instance_variable_get "@#{method_name}"
    else
      super
    end
  end

  private

  def fetch_full_data
    fields = (BASIC_PROPERTIES + OTHER_PROPERTIES).join ','
    params = {method: 'taobao.item.get', fields: fields, num_iid: id}
    result = Taobao.api_request(params)
    to_object result[:item_get_response][:item]
    @all_properties_fetched = true
    convert_types
  end

  def convert_types
    @price = @price.to_f
  end
end
