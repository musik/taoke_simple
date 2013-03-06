class Item < ActiveRecord::Base
  attr_accessible :all_properties_fetched, :click_url, :commission, :commission_num, :commission_rate, :commission_volume, :item_location, :nick, :num_iid, :pic_url, :price, :seller_credit_score, :shop_click_url, :title, :volume, :promotion_price
  belongs_to :shop
  scope :recent,order('id desc')
  scope :hot,order('commission_volume desc')

  define_index do
    indexes :title
    has :id
    has :shop_id
    set_property :delta => ThinkingSphinx::Deltas::ResqueDelta
  end
  def xearch *args
    ids = search_for_ids *args
    ids.present? ? where(:id=>ids) : []
  end
  def promotion?
    promotion_price != price
  end
  def self.quick_search q,limit=10
    search q,
      :match_mode=>:any,
      :per_page=>limit
  end

  def self.import_taoke_item taoke_item
    hash = taoke_item.as_json
    e = where(:num_iid=>taoke_item.num_iid).first_or_create(hash)
    e.update_attributes hash
    if e.shop_id.nil?
      e.shop = Shop.import_shop(taoke_item.shop)
      e.save
    end
    e
  end
end
