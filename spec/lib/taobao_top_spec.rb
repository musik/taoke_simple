# -*- encoding : utf-8 -*-
require File.dirname(__FILE__) + '/../spec_helper'

describe TaobaoTop do
  it "should be valid" do
    #pp TaobaoTop.new.get_roots
    #pp TaobaoTop.new.get_cat 'TR_MY'
    #pp TaobaoTop.new.get_cat 'TR_BB'
    #pp TaobaoTop.new.get_cat '50010518'
    #pp TaobaoTop.new.get_data 'TR_BBFS'
    #pp TaobaoTop.new.process
    #arr1 = TaobaoTop.new.get_keywords 16,:sn=>1000
    arr = TaobaoTop.new.get_brands 16
    #pp arr.select{|r| r.match(/Gree/).present?}
    pp arr.select{|r| r.length > 20}

    

  end
  it "should be valid" do
    # c = Cat.create :name=>"服饰",:oid=>"TR_FS"
    # TaobaoTop.new.get_root c 
  end
  it "should be valid" do
    # c = Cat.create :name=>"腰带",:oid=>"TR_NRDBPS&level3=TR_NSHYD"
    # c = Cat.create :name=>"宠物",:oid=>"TR_CW"
    # TaobaoTop.new.get_root c 
  end
   it "should be valid" do
    #c = Cat.create :name=>"衬衫",:oid=>"162104"
    # c.import_keywords
     # TaobaoTop.new.get_show c
    # c = Cat.create :name=>"衬衫",:oid=>"50020599"
    # TaobaoTop.new.get_show c    
  end
end
