# -*- encoding : utf-8 -*-
class TaobaoTop
  def initialize 
    @base = 'http://top.taobao.com/'
    @api_url = 'http://top.taobao.com/interface_v2.php'
  end
  def run
    get_cats
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
    rs
  end
  def get_brands catid
    get_keywords catid,:trtp=>3,:sn=>1000
  end
  def process cid = 16
    async_get_data cid
    cat = get_cat cid
    cats_children(cat).each do |id,r|
      if r["has_child"].zero?
        async_get_data id
      else
        process id
      end
    end
    return
  end
  def cats_children(cat)
    rs = {}
    cat["toprank_list"].each{|r|
      rs[r["CATEGORY_ID"]] = r
    }
    rs
  end
  def async_get_data catid
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
  def get_root root
    data = Typhoeus::Request.get("#{@base}interface2.php?cat=#{root.oid}").body
    require 'htmlentities'
    coder = HTMLEntities.new
    data = data.sub(/var \=/,'').sub(/\;$/,'')
    doc = Nokogiri::HTML(JSON.parse(data)["cats"])
    doc.css('dl').each do |dl|
      dt = dl.at_css('dt a')
      c = root.children.where(:name=>dt.text).first_or_create :oid=>href_to_oid(dt.attr('href'))
      pp c if Rails.env.test?
      
      if dl.css('dd').size >= 7
        delay.get_root c
      elsif dl.css('dd').size > 0
        dl.css('dd a').each do |a|
          cc = c.children.where(:name=>a.text).first_or_create :oid=>href_to_oid(a.attr('href'))
          delay.get_root cc
          pp cc if Rails.env.test?
        end
      end
    end
    
  end
  def run_keywords c
    %w(brand focus).each do |show|
      delay(:queue => 'cat',:priority=>2).get_show c,show,false
      delay(:queue => 'cat',:priority=>2).get_show c,show,true
    end
  end
  def get_show c,show="brand",up=false
    page = 0
    while 
      page+=1
      offset = (page-1)*30
      doc = fetch("#{@base}/level3.php?cat=#{c.oid}&show=#{show}&up=#{up}&offset=#{offset}")
      doc.at_css('.textlist').css('span.title').each do |n|
        t = Topic.where(:name=>n.at_css("a").text).first_or_create :volume=>n.parent.at_css("span.focus em").text.to_i
        # pp t if Rails.env.test?
      end
      break if doc.at_css('.pagination .page-bottom a.page-next').nil? 
    end
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
