# -*- encoding : utf-8 -*-
class TaobaoTop
  def initialize 
    @base = 'http://top.taobao.com/'
    @api_url = 'http://top.taobao.com/interface_v2.php'
  end
  #不保存数据
  def tmp_process cid = 16
    @thiskey = "keywords:#{cid}"
    get_keywords(cid).each{|r| Resque.redis.lpush @thiskey,r}
    cat = get_cat cid
    cats_children(cat).each do |id,r|
      if r["has_child"].zero?
        get_keywords(id).each{|r| Resque.redis.lpush @thiskey,r}
      else
        tmp_process id
      end
    end
    pp [cid,Resque.redis.llen(@thiskey)]
    return
  end
  def process cid = 16
    async_import_cat_data cid unless cid.nil?
    cat = get_cat cid
    cats_children(cat).each do |id,r|
      if r["has_child"].zero?
        async_import_cat_data id
      else
        process id
      end
    end
    return
  end
  def get_roots
    get_cat 
  end
  def get_cat name=nil
    data = fetch @api_url,:trtp=>2,:r=>true,:f=>'json',:nocache=>true,:cat=>name
    data["cat_toprank"]
  end
  #url http://top.taobao.com/interface_v2.php?f=html&ie=utf8&trtp=1&sn=1000&cat_ids=50013194
  #trtp 
    #1 宝贝销售榜
    #2 搜索榜
    #3 品牌榜
  #up: boolean 
    # true 上升
    # false 热门
  #goodsFilter
  #b2c 商城
  #c2c 集市
  def get_data catid,options={}
    defaults = {:trtp=>2,:f=>'html',:ie=>'utf8',:sn=>1000,:cat_ids=>catid}
    doc = fetch_html @api_url,defaults.merge(options)
  end
  def get_keywords catid,options={}
    doc = get_data catid,options
    rs = []
    doc.css('.keywordlist li a').each do  |a|
      if a.text.match(/\.\.\./).nil?
        rs << a.text
      else
        rs << CGI.unescape(a.attr('href').match(/q\=(.+?)\&/)[1],'GBK')
      end
    end
    rs.collect{|r| r.gsub(/ /,'')}
  end
  def get_brands catid
    get_keywords catid,:trtp=>3,:sn=>1000
  end
  def cats_children(cat)
    rs = {}
    cat["toprank_list"].each{|r|
      rs[r["CATEGORY_ID"]] = r
    }
    rs
  end
  @queue = "p3"
  def self.perform method,*args
    TaobaoTop.new.send(method, *args)
  end
  def async(method, *args)
    Resque.enqueue(TaobaoTop, method, *args)
  end
  def async_import_cat_data catid
    async(:import_cat_data,catid)
  end
  def import_cat_data catid
    keywords = get_keywords catid
    keywords.each do |r|
      Word.where(:name=>r).first_or_create
    end
    keywords = get_brands catid
    keywords.each do |r|
      Word.where(:name=>r).first_or_create :isbrand => true
    end
  end
  def href_to_oid str
    str.strip.match(/\=([\d\w\_]+)$/)[1]
  end
  def fetch(url,options={})
    res = Typhoeus::Request.get url,:params=>options
    JSON.parse(res.body.match(/.+?(\{.+\})/)[1])
  end
  def fetch_html(url,options={})
    res = Typhoeus::Request.get url,:params=>options
    Nokogiri::HTML(res.body)
  end
end
