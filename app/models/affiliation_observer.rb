class AffiliationObserver < ActiveRecord::Observer
  observe Affiliation

  def after_create(affiliation)

    # find or create organization
    org = Organization.find_by_OrgName(affiliation.name)
    
    # get user info
    user = User.includes(:host_profiles).find(affiliation.user_id)
    
    # add subscription if org is found
    unless org.blank?
      Subscription.find_or_create_by_channelID(org.wschannelID, :user_id=>user.id, :channelID => org.wschannelID, :contentsourceID => user.host_profiles[0].subscriptionsourceID) if user
    end
  end             
end