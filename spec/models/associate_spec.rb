require 'spec_helper'

describe Associate do

  before(:each) do
    @attr = {
      :email => "foo@foobar.com",
      :user_id => 1
    }
  end
  
 it "should accept valid email addresses" do
    addresses = %w[user@foo.com THE_USER@foo.bar.org first.last@foo.jp]
    addresses.each do |address|
      valid_email_user = Associate.new(@attr.merge(:email => address))
      valid_email_user.should be_valid
    end
  end

  it "should reject invalid email addresses" do
    addresses = %w[user@foo,com user_at_foo.org example.user@foo.]
    addresses.each do |address|
      invalid_email_user = Associate.new(@attr.merge(:email => address))
      invalid_email_user.should_not be_valid
    end
  end
end
