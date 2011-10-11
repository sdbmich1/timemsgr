module SubscriptionsHelper
  def set_class
    @channels.count < 3 ? 'set-btm nav-right' : 'nav-right'
  end
  
  def get_channel_name(val)
    Channel.find_by_channelID(val).try(:channel_name)
  end
end
