class Organization < KitsSubModel
  set_table_name 'allorg'
  set_primary_key 'ID'
  
  has_many :affiliations, :primary_key => :wschannelID, :foreign_key => :channelID
  has_many :users, :through => :affiliations
end
