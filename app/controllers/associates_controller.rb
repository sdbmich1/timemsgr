class AssociatesController < ApplicationController
    before_filter :authenticate_user!, :load_user
    	
#	respond_to :html, :json, :xml

	def load_user
		
		#set current user
  		@user = current_user  
	end

	def new
  		
  		# initialize model
  		@associate = @user.associates.new
 		
#		respond_with(@associate)	
	end
	
	def create
  		
  		# get email address 
 		@emails = params[:associate][:email].split(',')
		
		@emails.count.times do |n|
		  	@user.associates.build(:email => "#{@emails[n].strip}")  	
		end
		  		
  		respond_to do |format| 
    		if @user.save 
 #     			format.html { redirect_to(@user, :notice => 'Invitation(s)were successfully sent.') }  
     			format.html { redirect_to new_affiliation_path }  
      			format.xml  { render :xml => @user, :status => :created, :location => @user }  
    		else  
    			flash[:alert] = 'One or more email addresses were invalid.  Please re-enter.'
       			format.html { redirect_to new_associate_path  }  
 #   			format.html  { render :action => 'index' }  
 #    			format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }  
    		end  
  		end  			
	end
	
	def edit
		
	end
	
	def index
		
	end
	
	def update
		
	end
end
