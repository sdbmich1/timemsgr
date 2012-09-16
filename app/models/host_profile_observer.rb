class HostProfileObserver < ActiveRecord::Observer

  def after_update model
    check_promo_code model if model.changes[:promoCode]
  end
  
  private
  
  def check_promo_code model   
    hp_promo = HostProfile.find_promo_code model.promoCode, model.HostChannelID     
    hp_promo.map { |ch| ch.local_channels.map {|channel| Subscription.create(:user_id=>model.user.id, :channelID => channel.channelID, :contentsourceID => model.ssid)} }              
  end
end
