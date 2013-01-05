class TransactionsController < ApplicationController
  before_filter :authenticate_user!, :init_vars 
  before_filter :load_vars, :only => [:build, :create, :new, :show]
  layout :page_layout
  respond_to :html, :xml, :js, :mobile, :json

  def new
    @event = Event.find_event(@order[:id], @order[:etype], @order[:eid], @order[:sdt])
    @transaction = Transaction.load_new(@user)
  end
  
  def refund
    @transaction = Transaction.find(params[:id])
    @transaction.refund_transaction
  end
  
  def show
    @transaction = Transaction.find(params[:id])
  end
  
  def create
    @event = Event.find_event(@order[:id], @order[:etype], @order[:eid], @order[:sdt])
    @transaction = Transaction.new(params[:transaction])
    @transaction.save_transaction(params[:order])
  end
  
  def build
    @event = Event.find_event(@order[:id], @order[:etype], @order[:eid], @order[:sdt])
    @transaction = Transaction.load_new(@user)       
    if @order[:qtyCnt].to_i <= 0
      flash[:alert] = "Error submitting order form. No quantity amount entered." 
      render :action => 'new'
     end   
  end

  def index    
    @transactions = @user.profile.transactions
  end
    
  private
  
  def page_layout 
    if mobile_device?
      (%w(edit new build).detect { |x| x == action_name}) ? 'form' : 'application'
    end
  end  
  
  def init_vars
    @total = @fees = 0 
  end
  
  def load_vars    
    @order = action_name == 'build' ? params : params[:order] ? params[:order] : params
    @qtyCnt = action_name == 'new' ? @order[:qtyCnt].to_i : 0
  end
      
end
