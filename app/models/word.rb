class Word < ActiveRecord::Base
  attr_accessible :isbrand, :keywords, :name, :publish, :slug
  resourcify
  has_one :itemdata
  before_create :slug_gen
  after_create :init_data

  scope :recent,order('id desc')
  scope :published,where(:publish=>true)
  #scope :random,order('rand()')
  #scope :random,where('id >= (SELECT FLOOR( MAX(id) * RAND()) FROM `words` )')
  scope :short,select('name,slug')
  scope :random,lambda{|limit|
    #more = (limit * 1.5).ceil
    lid = select(:id).last.id - limit
    offset = rand(1..lid)
    where('id > ?',offset).limit(limit)
  }
  
  @queue = "word"
  def self.perform id,method,*args
    find(id).send(method, *args)
  end
  def async(method, *args)
    Resque.enqueue(Word, id, method, *args)
  end
  define_index do
    indexes :name
    has :id
    has :isbrand,:facets=>true
    where sanitize_sql(["publish", true])
    #set_property :delta => ThinkingSphinx::Deltas::ResqueDelta
  end
  DOMAIN = ENV["DOMAIN"]
  def to_url
    @url ||= "http://#{slug}#{DOMAIN}"
  end

  def init_data
    #Resque.enqueue UpdateKeywords,id
    #Resque.enqueue UpdateItems,id
    async(:with_delay,:update_keywords)
    async(:with_delay,:update_items)
  end
  def check_published
    update_attribute :publish,true if items.present?
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
  def title
    @title ||= begin
                 if keywords.present?  
                   arr = keywords.split(',')
                   ([name] + arr[0,3]).join('_')
                 else
                   name
                 end
               end
  end
  def keywords_hash
    @keywords_hash ||= (keywords.present? ? keywords.split(',') : [])
  end
  def random_slug
    #rand(479890..1679615).to_s 36
    ('a'..'z').to_a.sample(4).join('')
  end
  def update_keywords
    update_attribute :keywords,RelatedWords::Baidu.query(name).join(',')
  end
  def with_delay method
    keep_time 1 do
      send method rescue nil
    end
  end
  def update_keywords_with_delay
    keep_time 1 do
      update_keywords rescue nil
    end
  end
  def items
    itemdata.present? ? YAML.load(itemdata.data) : nil
  end
  def update_items
    url = 'http://s.m.taobao.com/search_turn_page_iphone.htm'
    response = Typhoeus::Request.get url,:params=>{:q=>name,:topSearch=>1,:from=>1,:sst=>1}
    if response.success?
      data = JSON.parse(response.body)
      Itemdata.where(:word_id=>id).first_or_create :data=>data["listItem"]
      check_published
    end
  end
  def related limit=10
    ids = Word.search_for_ids name.sub(/ /,''),
            :without=>{:id=>id},
            :match_mode => :any,
            :per_page => limit
    ids.present? ? Word.short.where(:id=>ids) : []
  end
  def preload
    Typhoeus::Request.get "#{to_url}/flush"
    Typhoeus::Request.get to_url
  end

  class << self
    def import
      where('id > 8733').find_each do |r|
          keep_time 1 do
            r.update_items
          end
      end
    end
    def preload
      select('id').find_each do |r|
        r.async :preload
      end
    end
  end
end
