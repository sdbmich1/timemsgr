class TsdEvent < KitsTsdModel
  set_table_name 'events'
  
  belongs_to :channel, :counter_cache => true

  has_many :session_relationships, :dependent => :destroy
  has_many :sessions, :through => :session_relationships, :dependent => :destroy

  has_many :event_presenters, 
           :finder_sql => proc { "SELECT e.* FROM kitstsddb.events e " +
              "INNER JOIN kitstsddb.event_presenters ep ON ep.event_id=e.id " +
              "WHERE ep.event_id=#{id}" }, 
           :dependent => :destroy
  has_many :presenters, :through => :event_presenters, 
           :finder_sql => proc { "SELECT p.* FROM kitstsddb.presenters p " +
              "INNER JOIN kitstsddb.event_presenters ep ON p.id=ep.presenter_id " +
              "WHERE ep.event_id=#{id}" },
           :dependent => :destroy

  has_many :event_sites, :dependent => :destroy
#  has_many :event_tracks, :dependent => :destroy
  has_many :pictures, :as => :imageable, 
            :finder_sql => proc { "SELECT p.* FROM kitstsddb.pictures p " +
            "WHERE p.imageable_id=#{id} " +
            "AND p.imageable_type = 'Event'" },
            :dependent => :destroy

  
end
