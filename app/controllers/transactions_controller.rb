class TransactionsController < ApplicationController
  before_filter :authenticate_user!
  layout :page_layout

  def new
    @event = Event.find_event(params[:eid], params[:etype])
    @transaction = Transaction.new(@user.attributes)
  end
  
  def show
    @transaction = Transaction.find(params[:id])
  end
  
  def create
    @transaction = Transaction.new(params[:transaction])
    if @transaction.save
      redirect_to events_url, :notice => "#{get_msg(@user, 'Transaction')}"
    else
      render :action => 'new'
    end
  end
  
  def edit
    @transaction = Transaction.find(params[:id])
  end

  def update
    @transaction = Transaction.find(params[:id])
    if @transaction.update_attributes(reset_dates(params[:transaction]))
      redirect_to events_url, :notice  =>  "#{get_msg(@user, 'Event')}"
    else
      render :action => 'edit'
    end
  end
  
  private
  
  def page_layout 
    if mobile_device?
      (%w(edit new).detect { |x| x == action_name}) ? 'form' : 'application'
    else
      "application"
    end
  end  
      
end
