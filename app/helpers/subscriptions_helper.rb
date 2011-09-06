module SubscriptionsHelper
  def set_class
    @channels.count < 3 ? 'set-btm nav-right' : 'nav-right'
  end
end
