#encoding: utf-8
require 'spec_helper'

describe Word do
  it "should gen slug" do
      c1 = Word.create :name=>"皮草 外套"
      #c1.update_keywords
      #pp c1.keywords
      c1.update_items

      #pp Word.create :name=>"haha",:slug=>c1.slug
  end
end
