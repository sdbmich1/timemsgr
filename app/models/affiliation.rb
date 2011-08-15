require 'rewards'
class Affiliation < ActiveRecord::Base
  include Rewards
  after_create :add_orgs
  before_save :add_rewards
  after_save :save_rewards

  attr_accessible :user_id, :name, :affiliation_type
  
  belongs_to :user, :foreign_key => :user_id
  
  validates :name, :presence => true  
  validates :affiliation_type, :presence => true, :unless => Proc.new { |a| a.name.blank? }  
  validates_uniqueness_of :name, :scope => :user_id
  
  def add_orgs
    Organization.find_or_create_by_name(self.name, :org_type => self.affiliation_type)
  end
  
  def add_rewards
    @reward_amt = add_credits(self.changes)
  end
  
  def save_rewards
    save_credits(self.user_id, 'Affiliations', @reward_amt)
  end
end
