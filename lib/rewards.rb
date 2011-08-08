module Rewards 
  def add_credits(*args)
    credit_amt = 0
    args[0].each do |key, item|
      reward = RewardCredit.find_by_name(key)
      credit_amt += reward.credits unless reward.blank? 
    end
    credit_amt
  end
  
  def save_credits(*args)
    UserCredit.create(:user_id => args[0], :context => args[1], :credits => args[2] )
  end
  
  def get_credits(userid)
    @credits = UserCredit.where('user_id = ?',userid).sum(:credits)
  end
  
  def get_last_credits(userid)
    @last_credits = UserCredit.where('user_id = ?',userid).last.credits
  end
  
  def get_msg(usr, tag)
    msg = "#{usr.first_name}, you now have #{get_credits(usr.id)} credits. " 
    msg += RewardMsg.find_by_msg_type(tag).description
  end
  
  def get_meter_info
    ProgressMeter.active
  end
end