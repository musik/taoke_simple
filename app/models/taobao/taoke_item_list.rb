class Taobao::TaokeItemList < Taobao::ProductList

  def order_by(field)
    clear_response
    @opts[:order_by] = field
    self
  end
  def fields(fields)
    @opts[:fields] = fields
    self
  end

  def total_count
    cached_responce[:items_get_response][:total_results].to_i
  end
  def self.search query
    self.new(keyword: query)
  end

  private
  def products
    items = cached_responce[:taobaoke_items_get_response][:taobaoke_items][:taobaoke_item]
    get_items_as_objects items
  rescue NoMethodError
    []
  end

  def get_items_as_objects(items)
    items.map { |item| Taobao::TaokeItem.new item }
  end

  def retrieve_response
    fields = @opts.has_key?(:fields) ? @opts.delete(:fields) : 'num_iid,title,nick,pic_url,price,click_url,commission,commission_rate,commission_num,commission_volume,shop_click_url,seller_credit_score,item_location,volume,promotion_price'
    params = {method: 'taobao.taobaoke.items.get', fields: fields}
    Taobao.api_request params.merge(@opts)
  end


end
