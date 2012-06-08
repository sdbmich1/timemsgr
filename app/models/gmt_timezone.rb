class GmtTimezone < KitsCentralModel
  set_table_name 'gmttimezones'
  
  def self.get_timezone cd
    tz = GmtTimezone.find_by_code cd
    tz.description if tz
  end
end
