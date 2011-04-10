class AssociatesController < ApplicationController
    before_filter :authenticate_user!
    	
#	respond_to :html, :json, :xml

	def new
		#set current user
  		@user = current_user  
  		
  		# initialize model
  		@associate = @user.associates.new
 		
#		respond_with(@associate)	
	end
	
	def create
		#set current user
  		@user = current_user  

		# set new associate data
  		@associate = @user.associates.new(params[:associate]) 
  		
  		# get email address 
 		@emails = params[:associate][:email].split(',')
		
		@emails.count.times do |n|
		  	@user.associates.build(:email => "#{@emails[n].strip}")  	
		end
		
   		# check for valid emails
 # 		validate_email(@user, @associate)
  		
  		respond_to do |format|  
    		if @user.save
      			UserMailer.invite_friends(@user).deliver  
      			format.html { redirect_to(@user, :notice => 'Associate was successfully created.') }  
      			format.xml  { render :xml => @user, :status => :created, :location => @user }  
    		else  
     			format.html { render :action => "new" }  
      			format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }  
    		end  
  		end  			
	end
	
	def update
		
	end
	
	def validate_email(*args)
		#set user
		@user = args.first
		
		#set associate
		@associate = args[1]
		
		# get email list
		@emails = @associate.email
				
		if !@emails.nil?
			
			# split emails
			@addresses = @emails.split(',')
			
			# set email address for each associate
			@addresses.count.times do |n|
#				@associate.email = address
				
				# add new associate
  				@associate = @user.associates.new(:email => @addresses[n])  
			end		
		end
	end
end
