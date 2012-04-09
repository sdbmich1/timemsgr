module SubscriptionsHelper
  def set_class
    return 'set-btm nav-right' unless @channels
    @channels.count < 3 ? 'set-btm nav-right' : 'nav-right'
  end
   
  def get_page_title(val)
    val ||= get_name_or_logo
  end
  
end
