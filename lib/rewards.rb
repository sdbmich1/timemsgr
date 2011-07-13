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
    msg = "#{usr.first_name}, you just earned #{get_last_credits(usr.id)} credits." 
    case tag
    when 'Welcome'
      msg += " You can earn up to 2,000 more credits by selecting your interests now."
    when 'Event'
      msg += " Earn more credits any time you add, update, or share an event."
    when 'Profile'
      msg += " You can earn more credits by adding events, adding friends, and much more." 
    when 'Subscription'
      msg += ' You can earn up to 500 more credits by entering your affiliations now.'
    when 'Interest'
      msg += ' Earn more credits by selecting your channels now.'
    end
  end
end