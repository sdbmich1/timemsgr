class UserEvent < ActiveRecord::Base
  set_table_name 'wsevents'
  
  scope :active, where(:status.downcase => 'active')
  scope :is_visible?, where(:hide.downcase => 'no')

  def self.upcoming(start_dt, end_dt)
    active.is_visible?.where("(eventstartdate >= date(?) and eventenddate <= date(?)) or (eventstartdate <= date(?) and eventenddate >= date(?))", start_dt, end_dt, start_dt, end_dt)
  end

  def self.observance(start_dt, end_dt)
    upcoming(start_dt, end_dt).where(:event_type => ['h', 'm'])
  end
end