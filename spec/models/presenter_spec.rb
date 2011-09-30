require File.dirname(__FILE__) + '/../spec_helper'

describe Presenter do
  it "should be valid" do
    Presenter.new.should be_valid
  end
end
