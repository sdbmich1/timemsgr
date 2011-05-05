class UserEvent < ActiveRecord::Base
	belongs_to :event
	belongs_to :user
	
	accepts_nested_attributes_for :user, :update_only => true #, :reject_if => lambda { |a| a[:title].blank? }

end
