class RewardObserver < ActiveRecord::Observer
  observe Affiliation, User, Interest

  def before_save(model)     
    @reward_amt = add_credits(model.changes)
  end

  def after_save(model)
    save_credits(model.user_id, 'User', @reward_amt)
  end
end