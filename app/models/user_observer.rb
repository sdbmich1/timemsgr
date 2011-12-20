class UserObserver < ActiveRecord::Observer
  observe User

  def after_create(user)
    
    # send welcome email
#    UserMailer.welcome_email(user).deliver

    # define channel id based on timestamp
    channelID = 'IN' + Time.now.to_i.to_s
    
    #create host profile
    hp = user.host_profiles[0]
    hp ||= user.host_profiles.build
    hp.ProfileType = 'Individual' 
    hp.LastName = user.last_name
    hp.FirstName = user.first_name
    hp.HostName = hp.FullName = user.name 
    hp.EMAIL = user.email
    hp.Gender = user.gender
    hp.StartMonth = user.created_at.month
    hp.StartDay = user.created_at.day
    hp.StartYear = user.created_at.year
    hp.EntityCategory = 'individual' 
    hp.EntityType = 'A' 
    hp.promoCode = user.promo_code 
    hp.status = 'active'
    hp.hide = 'no'
    hp.HostChannelID = channelID
    hp.subscriptionsourceID = channelID
    hp.save
    
    #create channel
    hp.channels.create(:channelID => channelID,
        :subscriptionsourceID => channelID, 
        :HostProfileID => hp.id, 
        :status => 'active', :hide => 'no',
        :channel_name => hp.HostName,
	      :channel_title => hp.HostName,
	      :channel_class => 'basic',
	      :channel_type => 'indhost')
	  
	  # add subscription if promo code is valid
    unless hp.try(:promoCode).blank?
      channel = Channel.where("channelID = ?", hp.promoCode)    
      Subscription.create(:user_id=>user.id, :channelID => channel[0].channelID, :contentsourceID => user.ssid) if channel
    end
  end
end
