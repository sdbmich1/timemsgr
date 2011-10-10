require 'spec_helper'

describe Category do

  before(:each) do
    @category = Factory.build(:category)
    @newcategory = Factory.create :category
  end

  it "should be valid" do
    @category.should be_valid
  end

    it "should have an events method" do
      @category.should respond_to(:events)
    end

    it "should have an interests method" do
      @category.should respond_to(:interests)
    end

    it "should have an channel_interests method" do
      @category.should respond_to(:channel_interests)
    end

    it "should have an channels method" do
      @category.should respond_to(:channels)
    end

  context '.get_active_list' do

    it "should respond to get_active_list method" do
      Category.should respond_to(:get_active_list)
    end

    it "should include active categories" do
      category = Factory(:category, :status => 'active')
      Category.get_active_list.should be_empty
    end

    it "should not list of unactive categories" do
      category = Factory(:category, :status => 'inactive')
      Category.get_active_list.should_not include(category)
    end
  end

  context '.unhidden' do

    it "should respond to unhidden method" do
      Category.should respond_to(:unhidden)
    end

    it "should include unhidden categories" do
      category = Factory(:category, :hide => 'no')
      Category.unhidden.should include(category)
    end

    it "should not list of unhidden categories" do
      category = Factory(:category, :hide => 'yes')
      Category.unhidden.should_not include(category)
    end
  end
end
