class UserObserver < ActiveRecord::Observer
  observe User

  def after_create(user)
    
    # send welcome email
    UserMailer.welcome_email(user).deliver

    # define channel id based on timestamp
    channelID = 'IN' + Time.now.to_i.to_s
    
    #create host profile
    hp = user.host_profiles.create(:ProfileType=>'Individual', 
        :HostName => user.first_name + ' ' + user.last_name,
        :StartMonth => user.created_at.month,
        :StartDay => user.created_at.day,
        :StartYear => user.created_at.year,
        :EntityCategory => 'individual', 
        :EntityType => 'A', 
        :status => 'active',
        :hide => 'no',
        :HostChannelID => channelID,
        :subscriptionsourceID => channelID)
    
   #create channel
   hp.channels.create(:channelID => channelID,
        :subscriptionsourceID => channelID, 
        :HostProfileID => hp.id, 
        :status => 'active', :hide => 'no',
        :channel_name => hp.HostName,
	      :channel_title => hp.HostName,
	      :channel_class => 'basic',
	      :channel_type => 'wshost')
  end
end
