require File.dirname(__FILE__) + '/../spec_helper'

describe Presenter do
  before(:each) do
    @presenter = Factory.build :presenter
    @newpresenter = Factory.build :presenter
  end

  it "should be valid" do
    @presenter.name = 'Test Name'
    @presenter.org_name = 'Test Inc'
    @presenter.bio = 'Test'
    @presenter.should be_valid
  end

  describe "name validations" do

    it "should have an presenter name" do
      @presenter.name = 'Test'
      @presenter.should be_valid
    end

    it "should reject invalid presenter name" do
      names = %w[user@foo,com user=_at_foo.org @@4$$?? example.user@foo.]
      names.each do |name|
        @presenter.name = name
        @presenter.should_not be_valid
      end
    end

    it "should not be valid without presenter name" do
      @presenter.name = nil
      @presenter.should_not be_valid
    end

    it "should reject duplicate presenter name" do
      presenter = Factory.create(:presenter, :name => 'Test Cat',  :org_name => 'Temp')
      dup_presenter = Factory.build(:presenter, :name => 'Test Cat',  :org_name => 'Temp')
      dup_presenter.should_not be_valid
    end

    it "should accept duplicate presenter name from different firm" do
      @attr = {:name => 'Test Dude', :org_name => 'Temp', :title => 'Title', :bio => 'Stuff'}
      presenter = Factory.create(:presenter, :name => 'Test Chick',  :org_name => 'Temp')
      new_presenter = Factory.build(:presenter, :name => 'Test Chick')
      new_presenter.org_name = 'DupTest'
      new_presenter.should be_valid
    end
  end

  describe "org_name validations" do

    it "should have an presenter org_name" do
      @presenter.org_name = 'Test@Planet9'
      @presenter.should be_valid
    end

    it "should reject invalid org name" do
      names = %w[user@foo=,com user=.org @@4$$?? example.+=@foo.]
      names.each do |name|
        @presenter.org_name = name
        @presenter.should_not be_valid
      end
    end

    it "should not be valid without presenter org_name" do
      @presenter.org_name = nil
      @presenter.should_not be_valid
    end
  end

  describe "bio validations" do

    it "should have an presenter bio" do
      @presenter.name = 'Test Name'
      @presenter.org_name = 'Test Inc'
      @presenter.bio = 'Test'
      @presenter.should be_valid
    end

    it "should not be valid without presenter bio" do
      @presenter.bio = nil
      @presenter.should_not be_valid
    end
  end

  describe 'event_presenters' do
    
    it "should have a event_presenters method" do
      @presenter.should respond_to(:event_presenters)
    end
  end

  describe 'events' do
    
    it "should have an events method" do
      @presenter.should respond_to(:events)
    end
  end

  describe 'pictures' do
    
    before(:each) do
      @newpresenter.save
      @sr = @newpresenter.pictures.build Factory.attributes_for(:picture)
    end

    it "should have a pictures method" do
      @presenter.should respond_to(:pictures)
    end

    it "has many pictures" do
      @newpresenter.pictures.should include(@sr)
    end

    it "should destroy associated pictures" do
      @newpresenter.destroy
      [@sr].each do |s|
        Picture.find_by_id(s.id).should be_nil
      end
    end
  end

  describe 'contact_details' do
    
    before(:each) do
      @newpresenter.save
      @sr = @newpresenter.contact_details.build Factory.attributes_for(:contact_detail)
    end

    it "should have a contact_details method" do
      @presenter.should respond_to(:contact_details)
    end

    it "has many contact_details" do
      @newpresenter.contact_details.should include(@sr)
    end

    it "should destroy associated contact_details" do
      @newpresenter.destroy
      [@sr].each do |s|
        ContactDetail.find_by_id(s.id).should be_nil
      end
    end
  end
end
