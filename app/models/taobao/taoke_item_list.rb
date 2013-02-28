class Taobao::TaokeItemList < Taobao::AbstractList

  def size
    items.size
  end

  def page(num)
    clear_response
    @opts[:page_no] = num
    self
  end

  def per_page(num)
    clear_response
    @opts[:page_size] = num
    self
  end

  def order_by(field)
    clear_response
    @opts[:order_by] = field
    self
  end

  def method_missing(method_name, *args, &block)
    if (m = /^order_by_(?<field>.+)$/.match method_name)
      order_by m[:field]
    else
      super
    end
  end

  def each(&block)
    items.each{ |item| block.call item }
  end

  def total_count
    cached_responce[:items_get_response][:total_results].to_i
  end
  def self.search query
    self.new(keyword: query)
  end

  private
  def items
    items = cached_responce[:taobaoke_items_get_response][:taobaoke_items][:taobaoke_item]
    get_items_as_objects items
  rescue NoMethodError
    []
  end

  def get_items_as_objects(items)
    items.map { |item| Taobao::TaokeItem.new item }
  end

  def retrieve_response
    fields = 'num_iid,title,nick,pic_url,price,click_url,commission,commission_rate,commission_num,commission_volume,shop_click_url,seller_credit_score,item_location,volume'
    params = {method: 'taobao.taobaoke.items.get', fields: fields}
    Taobao.api_request params.merge(@opts)
  end


end
