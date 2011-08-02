require 'rewards'
class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :set_user_time_zone, :load_credits #, :except => [:home, :contact]
  include Rewards

  def set_user_time_zone
    Time.zone = current_user.time_zone if user_signed_in?
  end
  
  def load_credits
    @credits = get_credits(current_user.id) if user_signed_in?
  end
end
