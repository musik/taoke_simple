#encoding: utf-8
require 'spec_helper'

describe Taobao::Shop do
  it "should fetch_full_data" do
    #pp Taobao::Shop.new({:nick=>'宝贝佳鑫2008',:click_url=>'http://'})
    #pp Taobao::Shop.new({:nick=>'hnhhbz',:click_url=>'http://'})

    #
    #nick = '静静儿玺玺'
    #nick = 'hnhhbz'
    #pp Taobao::Shop.new({:nick=>nick,:click_url=>'http://'})
    #nick = 'hnhhbz'
    #nick = '静静儿玺玺'
    #fields = [:sid,:cid,:nick,:title,:desc,:bulletin,:pic_path,:created,
     #:modified,:item_score,:service_score,:delivery_score].join(',')
    #params = {method: 'taobao.shop.get', fields: fields, nick: nick}
    #pp Taobao.api_request(params)
  end
end
