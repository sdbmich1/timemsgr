class RelationshipObserver < ActiveRecord::Observer
  include ProcessNotice
  observe :relationship
  
  def after_create(model)
    other_notice(model, 'request') 
  end

end
