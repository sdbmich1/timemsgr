class Affiliation < ActiveRecord::Base
  attr_accessible :user_id, :name, :affiliation_type
  
  belongs_to :user, :foreign_key => :user_id
#  belongs_to :affiliation_type
  
  validates :name,  :presence => true  
  validates :affiliation_type, :presence => true 
end
