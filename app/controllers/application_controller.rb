require 'rewards'
class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :load_settings
  include Rewards

  def load_settings
    if user_signed_in?
      Time.zone = current_user.time_zone
      @credits = get_credits(current_user.id)
      @meters = get_meter_info
    end 
  end
 
end
