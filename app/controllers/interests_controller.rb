class InterestsController < ApplicationController
  before_filter :load_data	
  layout :page_layout
	respond_to :html, :json, :xml, :js
  
	def new
		@categories = Category.active  # get category data
		respond_with(@interest = @user.interests.build)	
	end
	
	def create
    @user.attributes = {'interest_ids' => []}.merge(params[:user] || {})
    add_credits if @user.update_attributes(params[:user])
    respond_with(@user, :location => new_subscription_path) 
	end
	
	def edit
    @area = params[:p] # determine which user profile area to edit
    @categories = Category.active  # get category data
    respond_with(@interest = @user.interests) 
	end
	
	def update
    @user.attributes = {'interest_ids' => []}.merge(params[:user] || {}) 
    flash[:notice] = "#{get_msg(@user, 'Interest')}" if @user.update_attributes(params[:user])
    respond_with(@user, :location => home_path) 
	end

  def index
    @interests = Interest.find_interests(params[:category_id])
  end	
  
	protected
	
	def load_data
	  if user_signed_in?
      @selected_ids = @user.interest_ids  # check interest ids
    end
  end
	
	def add_credits
	  save_credits(@user.id, 'Interests', RewardCredit.find_by_name('interest_id').credits * params[:user][:interest_ids].count) if params[:user][:interest_ids]
    flash[:notice] = "#{get_msg(@user, 'Interest')}"
	end
	
	def page_layout  
    params[:p].blank? ? "application" : "users"  
  end  

end
