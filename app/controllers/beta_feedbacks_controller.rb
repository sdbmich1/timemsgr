class BetaFeedbacksController < ApplicationController
  layout :page_layout
  respond_to :html, :json, :xml, :js, :mobile

  def new
    @beta_questions = BetaQuestion.first
    @beta_feedback = BetaFeedback.new
  end
  
  def create
    @beta_feedback = BetaFeedback.create(params[:beta_feedback])
    respond_to do |format|
      format.html { redirect_to root_url } 
      format.mobile { redirect_to home_user_url }
      format.js { redirect_to root_url }
    end      
  end
  
  private
  
  def page_layout
    mobile_device? ? 'form' : 'users'
  end 
  
end
