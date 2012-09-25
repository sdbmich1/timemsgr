class InterestsController < ApplicationController
  before_filter :authenticate_user!#, :unless => :mobile_create?
  before_filter :load_data	
  layout :page_layout
	respond_to :html, :json, :xml, :js
  
	def new
		@categories = Category.get_active_list  # get category data
		@interest = @user.interests.build	
	end
	
	def create
    @user.attributes = {'interest_ids' => []}.merge(params[:user] || {})
    if @user.update_attributes(params[:user])
      complete_user_registration
      redirect_to events_path
    else
      render :action => 'new'
    end
	end
	
	def edit
    @area = params[:p] # determine which user profile area to edit
    @categories = Category.get_active_list  # get category data
    respond_with(@interest = @user.interests) 
	end
	
	def update
    @user ||= User.find(params[:id])
    @user.attributes = {'interest_ids' => []}.merge(params[:user] || {}) 
    flash[:notice] = "#{get_msg(@user, 'Interest')}" if @user.update_attributes(params[:user])
    respond_to do |format|
      format.mobile { redirect_to home_user_path }
      format.html { redirect_to edit_user_path(@user, :p => "Profile") }
    end
	end

  def index
    @interests = Interest.find_interests(params[:category_id])
  end	
  
	protected
	
	def load_data
	  if user_signed_in? && !mobile_device?
      @selected_ids = @user.interest_ids  # check interest ids
    end
  end
  
  def complete_user_registration
#    add_credits 
    @user.add_initial_subscriptions
  end
	
	def add_credits
	  save_credits(@user.id, 'Interests', RewardCredit.find_by_name('interest_id').credits * params[:user][:interest_ids].count) if params[:user][:interest_ids]
    flash[:notice] = "#{get_msg(@user, 'Interest')}"
	end
	
	def page_layout  
    mobile_device? ? 'form' : params[:p].blank? ? "application" : "users" 
  end  
  
  def mobile_create?
    mobile_device? && (action_name == 'create' || action_name == 'new')
  end

end
