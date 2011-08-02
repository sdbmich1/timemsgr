class EventType < ActiveRecord::Base
    default_scope :order => 'Code ASC'
end
