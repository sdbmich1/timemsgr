module UserInfo
  def oauth_user
    Thread.current[:user]
  end
 
  def self.oauth_user=(user)
    Thread.current[:user] = user
  end
end