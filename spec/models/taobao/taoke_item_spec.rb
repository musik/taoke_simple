
require 'spec_helper'

describe Taobao::TaokeItem do
  it "should convert title" do
    item = Taobao::TaokeItemList.search('iphone').first
    pp item
    pp item.shop.as_json
  end
end
