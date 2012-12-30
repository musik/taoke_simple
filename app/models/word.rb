class Word < ActiveRecord::Base
  attr_accessible :isbrand, :keywords, :name, :publish, :slug
  has_one :itemdata
  before_create :slug_gen
  after_create :init_data
  def init_data
    Resque.enqueue UpdateKeywords,id
    Resque.enqueue UpdateItems,id
  end
  def slug_gen
    base = self[:slug].present? ? self[:slug] : random_slug
    while self.class.select(:id).where(:slug=>base).first.present?
      base = random_slug
    end
    self[:slug] = base
  end
  def slug_regen
    update_attribute :slug,slug_gen
  end
  def random_slug
    #rand(479890..1679615).to_s 36
    ('a'..'z').to_a.sample(4).join('')
  end
  def update_keywords
    update_attribute :keywords,RelatedWords::Baidu.query(name).join(',')
  end
  def update_keywords_with_delay
    keep_time 1 do
      update_keywords rescue nil
    end
  end
  def items
    itemdata.present? ? itemdata.data : nil
  end
  def update_items
    url = 'http://s.m.taobao.com/search_turn_page_iphone.htm'
    response = Typhoeus::Request.get url,:params=>{:q=>name,:topSearch=>1,:from=>1,:sst=>1}
    if response.success?
      data = JSON.parse(response.body)
      Itemdata.where(:word_id=>id).first_or_create :data=>data["listItem"]
    end
  end

  class << self
    def import

    end
  end
end
