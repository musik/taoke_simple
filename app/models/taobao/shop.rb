class Taobao::Shop

  include Taobao::Util

  BASIC_PROPERTIES = [:sid,:cid,:nick,:title,:desc,:bulletin,:pic_path,:created,
     :modified,:item_score,:service_score,:delivery_score]

  attr_reader *BASIC_PROPERTIES

  def initialize(shop_properties)
    if Hash === shop_properties
      to_object shop_properties
      if shop_properties.size > 2
        @all_properties_fetched = false
        convert_types
      else
        fetch_full_data
      end
    else
      @nick = shop_properties.to_s
      fetch_full_data
    end
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
    fields = (BASIC_PROPERTIES).join ','
    params = {method: 'taobao.shop.get', fields: fields, nick: nick}
    result = Taobao.api_request(params)
    to_object result[:shop_get_response][:shop]
    @all_properties_fetched = true
    convert_types
  end

  def convert_types
    @created = DateTime.parse @created
    @modified = DateTime.parse @modified
  end
end
