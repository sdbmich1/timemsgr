class RelationshipObserver < ActiveRecord::Observer
  include ProcessNotice
  observe :relationship
  
  def after_create(model)
    other_notice(model, 'request') 
  end

  def after_update(model)
    model.status == 'accepted' ? other_notice(model, 'accept') : other_notice(model, 'reject') 
  end  

end
