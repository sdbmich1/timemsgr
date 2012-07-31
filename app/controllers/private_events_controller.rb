class PrivateEventsController < ApplicationController
  require 'will_paginate/array'
  before_filter :authenticate_user!, :unless => :mobile_create?
  include ResetDate, ImportEvent
  layout :page_layout

  def index
    load_events
  end

  def show
    @event = PrivateEvent.find_event(params[:eid])
  end

  def new
    @event = PrivateEvent.new 
  end

  def create
    @user ||= current_user
    @event = params[:private_event] ? PrivateEvent.new(reset_dates(params[:private_event])) : PrivateEvent.add_event(params[:id], params[:etype], @user.ssid, params[:eid], params[:sdate])
    if @event.save
      redirect_to events_url, :notice => "#{get_msg(@user, 'Event')}"
    else
      render :action => 'new'
    end
  end

  def edit
    @event = params[:eid] ? PrivateEvent.find_by_eventid(params[:eid]) : PrivateEvent.find(params[:id])
  end

  def update
    @event = PrivateEvent.find_event(params[:id])
    if @event.update_attributes(reset_dates(params[:private_event]))
      redirect_to events_url, :notice  => "#{get_msg(@user, 'Event')}"
    else
      render :action => 'edit'
    end
  end

  def destroy
    @user ||= current_user
    @pgType = params[:edate].to_date < Date.today ? 'past_page' : 'upcoming_page'
    @event = params[:eid] ? PrivateEvent.find_by_eventid(params[:eid]) : PrivateEvent.find(params[:id])
    @event.destroy ? flash[:notice] = "Removed event from schedule." : flash[:error] = "Unable to remove event from schedule."
    respond_to do |format|
      format.html { redirect_to events_url } 
      format.mobile { redirect_to events_url }
      format.js { load_events }
    end      
  end
    
  def clone 
    @event = params[:eid] ? PrivateEvent.find_by_eventid(params[:eid]).clone_event : PrivateEvent.find(params[:id]).clone_event 
  end
  
  def gcal_import
    email, pwd = params[:user][:email], params[:user][:password] # grab login parameters

    # import events from google calendar    
    if ImportEvent.gcal_import(email, pwd, @user)
      redirect_to private_events_url 
      flash[:notice] = "Your google calendar events have been successfully imported." 
    else
      flash[:error] = "Import events authentication failed.  Please re-enter your email and password." 
    end
  end
 
  private
  
  def page_layout 
    mobile_device? ? (%w(edit new).detect { |x| x == action_name}) ? 'form' : action_name == 'show' ? 'showitem' : 'pages' : "showevent"
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
end