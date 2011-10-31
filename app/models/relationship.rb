class Relationship < ActiveRecord::Base
  attr_accessible :user_id, :tracker_id, :rel_type, :status

  belongs_to :user
  belongs_to :tracker, :class_name => "User"

  validates :user_id, :presence => true
  validates :tracker_id, :presence => true, :uniqueness => { :scope => :user_id }
end