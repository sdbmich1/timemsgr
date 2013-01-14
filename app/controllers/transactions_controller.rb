class TransactionsController < ApplicationController
  before_filter  :init_vars 
  before_filter :load_vars, :except => [:index, :refund]
  before_filter :load_event, :only => [:new, :create, :build]
  before_filter :load_discount, :only => [:discount, :build, :create]
  layout :page_layout
  respond_to :xml, :js, :mobile, :json

  def new
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
    @transaction = Transaction.new(params[:transaction])
    @transaction.save_transaction(params[:order])
  end
  
  def build
    @transaction = Transaction.load_new(@user)       
    if mobile_qty_cnt?
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
  
  def mobile_qty_cnt?
    @order[:qtyCnt].to_i <= 0 && mobile_device?
  end
  
  def load_event
    @event = Event.find_event(@order[:id], @order[:etype], @order[:eid], @order[:sdt])    
  end
  
  def load_discount
    @discount = PromoCode.get_code(get_promo_code, Date.today) if get_promo_code
  end
  
  def get_promo_code
    params[:promo_code] || @order[:promo_code]
  end     
end
