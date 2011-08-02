class InterestsController < ApplicationController
  before_filter :authenticate_user!, :load_data	
	respond_to :html, :json, :xml, :js

  def load_data
  	@user = current_user  #set current user
		@selected_ids = @user.interest_ids  # check interest ids
  end
  
	def new
		@categories = Category.active  # get category data
		respond_with(@interest = @user.interests.build)	
	end
	
	def create
    @user.attributes = {'interest_ids' => []}.merge(params[:user] || {})
    save_credits(@user.id, 'Interests', RewardCredit.find_by_name('interest_id').credits * params[:user][:interest_ids].count) unless params[:user][:interest_ids].blank?
    flash[:notice] = "#{get_msg(@user, 'Interest')}" if @user.update_attributes(params[:user])
    respond_with(@user, :location => new_subscription_path) 
	end
	
	def edit
    @area = params[:p] # determine which user profile area to edit
	end
	
	def update
    @user.attributes = {'interest_ids' => []}.merge(params[:user] || {}) 
    flash[:notice] = "#{get_msg(@user, 'Interest')}" if @user.update_attributes(params[:user])
    respond_with(@user, :location => home_path) 
	end
end
