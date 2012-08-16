class RelationshipObserver < ActiveRecord::Observer
  include ProcessNotice
  observe :relationship
  
  def after_create(model)
    other_notice(model, 'request') 
  end

  def after_update(model)
    if model.status == 'accepted' 
      other_notice(model, 'accept') 
      
      # add birth dates to each persons calendar
      LifeEvent.set_rel_birth_date model
    else 
      other_notice(model, 'reject')
    end  
  end 
  
  def after_destroy model
    other_notice model, 'delete'
  end 

end
