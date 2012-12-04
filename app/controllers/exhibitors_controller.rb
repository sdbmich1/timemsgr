class ExhibitorsController < ApplicationController
  before_filter :authenticate_user!
  layout :page_layout
  
  def index
    @event = Event.find_event(params[:id], params[:etype], params[:eid], params[:sdt])
    @exhibitors = @event.exhibitors rescue nil
  end

  def show
    @event = Event.find_event(params[:event_id], params[:etype], params[:eid], params[:sdt])
    @exhibitor = Exhibitor.find(params[:id])
  end

  private
  
  def page_layout 
    if mobile_device? 
      (action_name == 'show') ? 'showitem' : "list"
    else
      'showevent'
    end 

  end    
end
