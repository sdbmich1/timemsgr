class Organization < ActiveRecord::Base
  set_table_name 'allorg'
  set_primary_key 'ID'
  
  has_many :affiliations, :primary_key => :wschannelID, :foreign_key => :channelID
  has_many :users, :through => :affiliations
  
  define_index do
    indexes :OrgName, :sortable => true
   
    has :ID, :as => :org_id
    set_property :enable_star => 1
    set_property :min_prefix_len => 3
  end      
end
