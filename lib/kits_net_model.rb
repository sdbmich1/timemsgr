require 'active_record'

class KitsNetModel < ActiveRecord::Base
  self.abstract_class = true
  establish_connection "kits_net"
end