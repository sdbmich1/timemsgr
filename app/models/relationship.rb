class Relationship < ActiveRecord::Base
  attr_accessible :tracked_id, :tracker_id, :rel_type, :status

  belongs_to :tracker, :class_name => "User"
  belongs_to :tracked, :class_name => "User"

  validates :tracked_id, :presence => true
  validates :tracker_id, :presence => true, :uniqueness => { :scope => :tracked_id }
  validates :rel_type, :presence => true
  validates :status, :presence => true
  
  def self.set_status(trkr_id, trkd_id)
    relationship = Relationship.get_relationship(trkd_id, trkr_id)
    relationship.status = 'accepted' rescue nil
    relationship
  end
  
  def self.get_status(trkd_id, trkr_id)
    relationship = Relationship.get_relationship(trkd_id, trkr_id)
    relationship.status.titleize if relationship
  end
  
  def self.get_rel_type(trkd_id, trkr_id)
    relationship = Relationship.get_relationship(trkd_id, trkr_id)
    relationship.rel_type.titleize if relationship
  end
  
  def self.get_relationship(trkd_id, trkr_id)
    Relationship.find_by_tracked_id_and_tracker_id(trkd_id, trkr_id) || Relationship.find_by_tracked_id_and_tracker_id(trkr_id, trkd_id)    
  end
  
end