class PresentersController < ApplicationController
  def index
    @presenters = Presenter.get_event_list(params[:event_id])
  end

  def show
    @presenter = Presenter.find(params[:id])
  end

end
