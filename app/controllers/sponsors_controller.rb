class SponsorsController < ApplicationController
  before_filter :authenticate_user!
  layout :page_layout
  
  def index
    @event = Event.find_event(params[:id], params[:etype], params[:eid], params[:sdt])
    @sponsors = @event.sponsors rescue nil
  end

  def show
    @event = Event.find_event(params[:event_id], params[:etype], params[:eid], params[:sdt])
    @sponsor = Sponsor.find(params[:id])
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
