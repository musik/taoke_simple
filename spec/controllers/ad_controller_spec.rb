require 'spec_helper'

describe AdController do

  describe "GET 'index'" do
    it "returns http success" do
      get 'index'
      response.should be_success
    end
  end

  describe "GET 'display'" do
    it "returns http success" do
      get 'display'
      response.should be_success
    end
  end

end
