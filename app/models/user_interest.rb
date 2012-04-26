class UserInterest < KitsTsdModel
  belongs_to :user
  belongs_to :interest
  
  def user_name
    user.name if user
  end  
end
