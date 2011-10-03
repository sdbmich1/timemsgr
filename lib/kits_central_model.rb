require 'active_record'

class KitsCentralModel < ActiveRecord::Base
  self.abstract_class = true
  establish_connection "kits_central"
end