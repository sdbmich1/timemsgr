class Affiliation < ActiveRecord::Base
  after_create :add_orgs
  attr_accessible :user_id, :name, :affiliation_type
  
  belongs_to :user, :foreign_key => :user_id
#  belongs_to :affiliation_type
  
  validates :name,  :presence => true  
  validates :affiliation_type, :presence => true 
  
  def add_orgs
    Organization.find_or_create_by_name(self.name, :org_type => self.affiliation_type)
  end
end
