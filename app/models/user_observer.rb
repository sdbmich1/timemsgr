class UserObserver < ActiveRecord::Observer
  include ProcessNotice, Rewards
  observe User
  
  def after_save(model)
    save_credits(model.id, 'Profile', @reward_amt) unless @reward_amt.blank? || @reward_amt == 0
  end
  
  def before_save(model)
    @reward_amt = add_credits(model.changes)   
  end

  def after_create(user)
    
    # define channel id based on timestamp
    channelID = 'IN' + Time.now.to_i.to_s
    
    #create host profile
    hp = user.profile
    hp ||= user.host_profiles.build
    hp.LastName, hp.FirstName = user.last_name, user.first_name 
    hp.HostName = hp.FullName = user.name 
    hp.EMAIL, hp.Gender = user.email, user.gender
    hp.StartMonth, hp.StartDay, hp.StartYear  = user.created_at.month, user.created_at.day, user.created_at.year
    hp.ProfileType, hp.EntityCategory, hp.EntityType = 'Individual','individual','A'  
    hp.promoCode, hp.status, hp.hide = user.promo_code, 'active', 'yes' 
    hp.HostChannelID = hp.subscriptionsourceID = channelID
    hp.save
    
    #create channel
    hp.channels.create(:channelID => channelID, :subscriptionsourceID => channelID, :HostProfileID => hp.id, 
        :status => 'active', :hide => 'yes', :channel_name => hp.HostName, :channel_title => hp.HostName,
	      :channel_class => 'basic', :channel_type => 'indhost')
	  
	  # add subscription if promo code is valid
    unless user.promo_code.blank?
      hp_promo = HostProfile.find_promo_code user.promo_code
      unless hp_promo.blank?
        hp_promo.channels.each do |channel|
          Subscription.create(:user_id=>user.id, :channelID => channel.channelID, :contentsourceID => user.ssid) if channel       
        end
      end
    end
    
    # subscribe to local channels
#    local_channels = LocalChannel.where('localename = ?', user.location)    
#    local_channels.each do |channel|
#      Subscription.create(:user_id=>user.id, :channelID => channel.channelID, :contentsourceID => user.ssid) if channel
#    end
    
    # process notice
    newuser_notice(user)
    
    # send welcome email
    UserMailer.delay.welcome_email(user)    
  end
end
