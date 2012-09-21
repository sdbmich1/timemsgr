class UserObserver < ActiveRecord::Observer
  include ProcessNotice, Rewards, UserInfo
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
    hp.LastName, hp.FirstName, hp.EMAIL, hp.Gender = user.last_name, user.first_name, user.email, user.gender 
    hp.HostName = hp.FullName = user.name 
    hp.StartMonth, hp.StartDay, hp.StartYear  = user.created_at.month, user.created_at.day, user.created_at.year
    hp.ProfileType, hp.EntityCategory, hp.EntityType, hp.status, hp.hide = 'Individual','individual','A', 'active', 'yes'   
    hp.promoCode = user.promo_code
    hp.HostChannelID = hp.subscriptionsourceID = channelID
    hp.City, hp.State = user.city.split(', ')[0], user.city.split(', ')[1] if user.city
#    hp.EducationalInst, hp.PoliticalAffiliation1, hp.Religion = oauth_user.education, oauth_user.party, oauth_user.religion if oauth_user
    hp.save
        
    #create channel
    hp.channels.create(:channelID => channelID, :subscriptionsourceID => channelID, :HostProfileID => hp.id, 
        :status => 'active', :hide => 'yes', :channel_name => hp.HostName, :channel_title => hp.HostName,
	      :channel_class => 'basic', :channel_type => 'indhost')
        
    # set up initial subscriptions
    add_subscriptions user
    
    # process notice
    newuser_notice(user)
    
    # send welcome email
    DelayClassMethod.new("UserMailer", "welcome_email", :params=>[user]).delay
    #UserMailer.delay.welcome_email(user)    
  end
  
  def before_update user
    # add subscriptions if promo code is valid    
    if user.changes[:promo_code]
      hp = user.profile 
      hp.promoCode = user.promo_code
      hp.save
      
      check_promo_code(user) unless user.promo_code.blank?
    end
  end
  
  private
  
  def add_subscriptions user
    
    # load user interests from oauth api
    if oauth_user
      oauth_user.interests.each do |interest| 
        int = Interest.find_or_add_interest interest.name
        UserInterest.create :user_id=>user.id, :interest_id=>int.id
        
        # find correct channel based on location
        cid = LocalChannel.select_channel(interest.name, user.city, user.location)
        cid.map { |ch| ch.map {|channel| Subscription.find_or_create_by_user_id_and_channelID(user.id, channel.channelID) {|u| u.contentsourceID = user.ssid}} } if cid   
      end
      
      # match education to channels
      oauth_user.education.each do |ed|
        cid = LocalChannel.select_channel ed.school.name, user.city, user.location
        cid.map { |ch| ch.map {|channel| Subscription.find_or_create_by_user_id_and_channelID(user.id, channel.channelID) {|u| u.contentsourceID = user.ssid}} } if cid   
      end

      # match likes to channels
      oauth_user.likes.each do |lk|
        cid = LocalChannel.select_channel lk.name, user.city, user.location
        cid.map { |ch| ch.map {|channel| Subscription.find_or_create_by_user_id_and_channelID(user.id, channel.channelID) {|u| u.contentsourceID = user.ssid}} } if cid   
      end
    end
    
    # add subscriptions if promo code is valid
    check_promo_code(user) unless user.promo_code.blank?
    
    # add system channels for given location
#    cid = LocalChannel.select_system_channels(user.profile.City, user.location)
#    cid.map { |ch| ch.map {|channel| Subscription.create(:user_id=>user.id, :channelID => channel.channelID, :contentsourceID => user.ssid) }}    
  end
  
  def check_promo_code user   
    hp_promo = HostProfile.find_promo_code user.promo_code, user.ssid      
    hp_promo.map { |hp| hp.local_channels.map {|channel| Subscription.create(:user_id=>user.id, :channelID => channel.channelID, :contentsourceID => user.ssid)} }              
  end
end
