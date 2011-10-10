require 'spec_helper'

describe ContactDetail do

  before(:each) do
    @presenter = Factory(:presenter)
    @contact_detail = @presenter.contact_details.build(:work_email => 'test@gmail.com') 
  end

  describe "instance validations" do

    it "should be valid" do
      @contact_detail.should be_valid
    end

     it "should create a new instance given valid attributes" do
       @contact_detail.save!
     end

  end

  describe "validations" do

    it "should accept valid work email addresses" do
      addresses = %w[user@foo.com THE_USER@foo.bar.org first.last@foo.jp]
      addresses.each do |address|
        @contact_detail.work_email = address
        @contact_detail.should be_valid
      end
    end

    it "should reject invalid work_email addresses" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo.]
      addresses.each do |address|
        @contact_detail.work_email = address
        @contact_detail.should_not be_valid
      end
    end
  end

end
