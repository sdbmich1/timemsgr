class Promotion < ActiveRecord::Base
  attr_accessible :name, :promo_type, :start_date, :start_time, :end_date, :end_time, :sponsor_id, :promo_fee, :promo_descr
end
