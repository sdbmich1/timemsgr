module Schedule
  
  def get_opportunities
    events = []
    t = Time.now
    3.times do |i|
      start_time = Time.at(t.to_i - t.sec - t.min % 15 * 60).advance(:hours => i + 1)
      end_time = Time.at(t.to_i - t.sec - t.min % 15 * 60).advance(:hours => i + 2)
      events << {:start_date => Date.today, :start_time => start_time, :end_time => end_time}
    end
    return events
  end
end