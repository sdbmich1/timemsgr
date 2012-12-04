module EventSessionsHelper

  def date_diff dt
    (dt.to_date - Date.today).to_i
  end  
end
