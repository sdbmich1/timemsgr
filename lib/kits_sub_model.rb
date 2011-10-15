require 'active_record'

class KitsSubModel < ActiveRecord::Base
  self.abstract_class = true
  establish_connection "kits_sub"
end