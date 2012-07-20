class ReminderObserver < ActiveRecord::Observer
  observe Reminder
 
  def before_destroy model
    dj = Delayed::Job.find_by_id(model.delayed_job_id)
    dj.delete if dj
  end
  
  def after_update model
    dj = Delayed::Job.find_by_id(model.delayed_job_id)
    if dj 
      dj.run_at = model.starttime
      dj.save 
    end   
  end
end
