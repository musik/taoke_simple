class Shop < ActiveRecord::Base
  attr_accessible :all_properties_fetched, :bulletin, :cid, :click_url, :created, :desc, :modified, :nick, :pic_path, :sid, :title
  has_many :items
  #scope :top,order('')
  scope :recent,order('id desc')
  define_index do
    indexes :title,:nick
    has :id
    set_property :delta => ThinkingSphinx::Deltas::ResqueDelta
  end

  def pic_url
    "/shoplogo#{pic_path}"
  end
  def self.quick_search q,limit=10,options={}
    search q,{:match_mode=>:any,:per_page=>limit}.merge(options)
  end
  def self.import_shop shop
    hash = shop.as_json
    e = where(:sid=>shop.sid).first_or_create(hash)
    e.update_attributes hash
    e
  end
end
