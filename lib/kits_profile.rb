require 'active_record'

class KitsProfileModel < ActiveRecord::Base
  self.abstract_class = true
  establish_connection "kits_profile"
end