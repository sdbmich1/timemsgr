class PrivateEventsController < ApplicationController
  require 'will_paginate/array'
  before_filter :authenticate_user!
  before_filter :set_page_type, :if => :html_destroy?
  include ResetDate, ImportEvent
  layout :page_layout
  respond_to :html, :xml, :js, :mobile, :json

  def index
    load_events
  end

  def show
    @event = PrivateEvent.find(params[:id])
  end

  def new
    @event = PrivateEvent.build_event(params[:sdt])
  end

  def create
    @user ||= current_user
    @event = PrivateEvent.new_event(params[:private_event], params[:id], params[:etype], @user.ssid, params[:eid], params[:sdate])
    if @event.save(:validate=>myEvent?)
      redirect_to events_url, :notice => "#{get_msg(@user, 'Event')}"
    else
      render :action => 'new'
    end
  end

  def edit
    @event = PrivateEvent.locate_event(params[:id], params[:eid])
  end

  def update
    @event = PrivateEvent.find(params[:id])
    if @event.update_attributes(ResetDate::reset_dates(params[:private_event]))
      redirect_to events_url, :notice  => "#{get_msg(@user, 'Event')}"
    else
      render :action => 'edit'
    end
  end

  def destroy
    @event = PrivateEvent.locate_event(params[:id], params[:eid])
    @event.destroy ? flash[:notice] = "Removed event from schedule." : flash[:error] = "Unable to remove event from schedule."
    respond_to do |format|
      format.html { redirect_to events_url } 
      format.mobile { redirect_to events_url }
      format.js { mobile_device? ? redirect_to(events_url) : load_events }
    end      
  end
    
  def clone 
    @event = PrivateEvent.locate_event(params[:id], params[:eid]).clone_event 
  end
  
  def gcal_import
    email, pwd = params[:uid], params[:pwd] # grab login parameters

    # import events from google calendar    
    if ImportEvent.gcal_import(email, pwd, @user)
      flash[:notice] = "Your google calendar events have been successfully imported." 
      load_events
    else
      flash[:error] = "Import events authentication failed.  Please re-enter your email and password." 
    end
  end
 
  private
  
  def page_layout 
    if mobile_device? 
      action_name == 'show' ? 'showitem' : action_name == 'index' ? 'activities' : 'form' 
    else
      action_name == 'show' ? "showevent" : 'events'
    end
  end
  
  def offset
    mobile_device? ? 30 : 15
  end

  def sdate
    @start_date = params[:sdate]    
  end  
  
  def pgType
    params[:param_name] ? @pgType = params[:param_name] : @pgType   
  end 
  
  def getPgType type
    pgType ? pgType == type ? true : false : true
  end
  
  def load_events
    @events = PrivateEvent.current_events(@user.ssid).paginate(:page=>params[:page], :per_page => offset) if getPgType('upcoming_page')
    @past_events = PrivateEvent.past_events(@user.ssid).paginate(:page=>params[:page], :per_page => offset) if getPgType('past_page')    
  end

  def mobile_create?
    mobile_device? && action_name == 'create'
  end
  
  def html_destroy?
    !mobile_device? && action_name == 'destroy'
  end

  def myEvent?
    !params[:private_event].blank?
  end  
  
  def set_page_type
    @pgType = params[:edate].to_date < Date.today ? 'past_page' : 'upcoming_page' rescue nil
  end
end