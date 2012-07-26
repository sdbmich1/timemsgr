module AffiliationsHelper
  
  def getBtnTag action
    action == 'new' ? 'Finish' : 'Save'
  end
end
