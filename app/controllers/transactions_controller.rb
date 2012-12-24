class TransactionsController < ApplicationController
  before_filter :authenticate_user! 
  before_filter :load_vars, :only => [:index, :create, :new]
  layout :page_layout

  def new
    @event = Event.find_event(@order[:id], @order[:etype], @order[:eid], @order[:sdt])
    @transaction = Transaction.load_new(@user)
  end
  
  def show
    @transaction = Transaction.find(params[:id])
  end
  
  def create
    @transaction = Transaction.new(params[:transaction])
    @transaction.save_transaction
  end

  def index    
    @transaction = Transaction.load_new(@user)
  end
    
  private
  
  def page_layout 
    if mobile_device?
      (%w(edit new).detect { |x| x == action_name}) ? 'form' : 'application'
    else
      "application"
    end
  end  
  
  def load_vars
    @total = 0   
    @order = action_name == 'index' ? params : params[:order]
    @qtyCnt = action_name == 'new' ? @order[:qtyCnt].to_i : 0
  end
      
end
