require 'spec_helper'

describe Picture do

  before(:each) do
    @file = "/spec/fixtures/photo.jpg" 
    @presenter = Factory(:presenter)
    @event = Factory(:event)
    @channel = Factory(:channel)
    @picture = @presenter.pictures.build(:photo_file_name => @file)
    @evpicture = @event.pictures.build(:photo_file_name => @file)
    @channel_picture = @channel.pictures.build(:photo_file_name => @file)
  end

  describe "presenter photo validations" do

    it "should be valid" do
      @picture.should be_valid
    end

    it "should create a new instance given valid attributes" do
      @picture.save!
    end

    context "check presenter photo attributes" do
      before(:each) do
        @picture.save!
      end

      it "should receive photo_file_name from :photo" do 
        @picture.photo_file_name.should == @file
      end
    end

    context "check event photo attributes" do
      before(:each) do
        @evpicture.save!
      end

      it "should receive photo_file_name from :photo" do 
        @evpicture.photo_file_name.should == @file
      end
    end

    context "check channel photo attributes" do
      before(:each) do
        @channel_picture.save!
      end

      it "should receive photo_file_name from :photo" do 
        @channel_picture.photo_file_name.should == @file
      end
    end

  end
end
