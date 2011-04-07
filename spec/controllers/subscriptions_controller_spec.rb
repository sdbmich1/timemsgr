require 'spec_helper'

describe SubscriptionsController do
  render_views

  describe "GET 'new'" do
    it "should be successful" do
      get 'new'
      response.should be_success
    end
  end

  describe "GET 'channels'" do
    it "should be successful" do
      get 'channels'
      response.should be_success
    end
  end
end
