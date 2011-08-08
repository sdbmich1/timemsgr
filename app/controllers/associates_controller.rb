class AssociatesController < ApplicationController
  before_filter :authenticate_user!, :load_user    	
	respond_to :html, :json, :xml

	def load_user
  	@user = current_user  #set current user
	end

	def new
		respond_with(@associate = @user.associates.new)	
	end
	
	def create
 		@emails = params[:associate][:email].split(',') # get email address
		@emails.count.times do |n|
		  	@user.associates.build(:email => "#{@emails[n].strip}") # parse each email address
		end
		  		
		flash[:notice] = "#{get_msg(@user, 'Event')}" if @user.save          
    respond_with(@user, :location => home_url)		
	end
end
