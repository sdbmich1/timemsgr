# used to build initial subscription list for new users
class BuildUserSubscriptions
  def initialize(channel_name, model_name, options={})
    @channel_name = channel_name
    @model_name = model_name
    @parameters = options[:params] || []
  end

  def create
    cid = LocalChannel.select_channel @channel_name, @model_name.city, @model_name.location
    cid.map { |ch| ch.map {|channel| Subscription.find_or_create_by_user_id_and_channelID(@model_name.id, channel.channelID) {|u| u.contentsourceID = @model_name.ssid}} } if cid       
  end
end 