class PresentersController < ApplicationController
  def index
    @presenters = Event.find(params[:event_id]).try(:presenters)
  end

  def show
    @presenter = Presenter.find(params[:id])
  end

end
