require 'spec_helper'

describe ItemsController do

  describe "GET 'recent'" do
    it "returns http success" do
      get 'recent'
      response.should be_success
    end
  end

  describe "GET 'hot'" do
    it "returns http success" do
      get 'hot'
      response.should be_success
    end
  end

end
