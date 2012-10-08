class PresentersController < ApplicationController
  before_filter :authenticate_user!
  layout :page_layout
  
  def index
    @event = Event.find_event(params[:id], params[:etype], params[:eid], params[:sdt])
    @presenters = @event.presenters rescue nil
  end

  def show
    @presenter = Presenter.find(params[:id])
  end

  private
  
  def page_layout 
    mobile_device? && (action_name == 'show') ? 'showitem' : "list" 
  end    

end
