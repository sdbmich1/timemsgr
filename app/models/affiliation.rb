require 'rewards'
class Affiliation < ActiveRecord::Base
  include Rewards
  before_save :add_rewards, :add_org
  after_save :save_rewards

  attr_accessible :user_id, :name, :affiliation_type
  
  belongs_to :user
  belongs_to :organization, :foreign_key => :wschannelID
  
  validates :name, :presence => true  
  validates :affiliation_type, :presence => true, :unless => Proc.new { |a| a.name.blank? }  
  validates_uniqueness_of :name, :scope => :user_id
  
  def add_org   
    channelID = 'SC' + Time.now.to_i.to_s  # define channel id based on timestamp
    org = Organization.find_or_create_by_OrgName(self.name, :OrgName =>self.name, :wschannelID => channelID,
                    :status => 'active', :hide => 'no')
    self.channelID = org.wschannelID
  end
  
  def add_rewards
    @reward_amt = add_credits(self.changes)
  end
  
  def save_rewards
    save_credits(self.user_id, 'Affiliations', @reward_amt)
  end
end
