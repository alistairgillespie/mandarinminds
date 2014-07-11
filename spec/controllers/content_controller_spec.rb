require 'spec_helper'

describe ContentController do

  describe "GET 'ten'" do
    it "returns http success" do
      get 'ten'
      response.should be_success
    end
  end

  describe "GET 'twenty'" do
    it "returns http success" do
      get 'twenty'
      response.should be_success
    end
  end

  describe "GET 'fifty'" do
    it "returns http success" do
      get 'fifty'
      response.should be_success
    end
  end

  describe "GET 'hundred'" do
    it "returns http success" do
      get 'hundred'
      response.should be_success
    end
  end

end
