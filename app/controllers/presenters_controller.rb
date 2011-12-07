class PresentersController < ApplicationController
  before_filter :authenticate_user!
  layout :page_layout
  
  def index
    @presenters = Event.find(params[:event_id]).try(:presenters)
  end

  def show
    @presenter = Presenter.find(params[:id])
  end

  private
  
  def page_layout 
    mobile_device? ? 'application' : 'events'
  end    

end
