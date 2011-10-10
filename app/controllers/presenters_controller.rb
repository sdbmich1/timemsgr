class PresentersController < ApplicationController
  def index
    @presenters = Event.get_event_details(params[:event_id]).presenters
  end

  def show
    @presenter = Presenter.find(params[:id])
  end

end
