require 'active_record'

class KitsTsdModel < ActiveRecord::Base
  self.abstract_class = true
  establish_connection "kits_tsd"
end