class Transaction < KitsTsdModel
  attr_accessible :code, :description, :amt, :currency, :transaction_date, 
  :channelID, :HostProfileID, :user_id, :status, :hide, :BillingAddr,
  :first_name, :last_name, :City, :State, :PostalCode, :Phone_Home, :token, :credit_card_no,
  :Phone_Work, :payment_type,  :Address2, :confirmation_no, :email, :expiration_date, :Country, :promo_code
  
  attr_accessor :cvv, :promo_code
  
  belongs_to :host_profile, :foreign_key => :HostProfileID
  
  has_many :transaction_details
  
  name_regex =  /^[A-Z]'?['-., a-zA-Z]+$/i
  text_regex = /^[-\w\,. _\/&@]+$/i
  money_regex = /^\$?(?:\d+)(?:.\d{1,2}){0,1}$/
 
  # validate added fields           
  validates :first_name,  :presence => true,
                :length   => { :maximum => 30 },
                :format => { :with => name_regex }  
  validates :last_name,  :presence => true,
                :length   => { :maximum => 30 },
                :format => { :with => name_regex }
  validates :Company,  :allow_blank => true, 
                       :length   => { :maximum => 50 }  
  validates :BillingAddr,  :presence => true,
                       :length   => { :maximum => 50 },
                       :format => { :with => text_regex }  
  validates :Address2, :allow_blank => true,
                       :length   => { :maximum => 50 },
                       :format => { :with => text_regex } 
  validates :Phone_Home, :presence => true, 
                    :length   => { :minimum => 10 }
  validates :email, :presence => true, :email_format => true
  validates :City,  :presence => true,
                       :length   => { :maximum => 50 },
                       :format => { :with => name_regex }  
  validates :State, :presence => true
  validates :Country, :presence => true
  validates :amt, :presence => true  
    
  def self.load_new(usr)
    new_transaction = usr.profile.transactions.build usr.profile.attributes if usr.profile
    new_transaction.user_id = usr.id
    new_transaction.first_name = usr.first_name
    new_transaction.last_name = usr.last_name
    new_transaction.email = usr.email
    new_transaction.BillingAddr = usr.profile.Address1
#    new_transaction.HostProfileID = usr.profile.id
    new_transaction
  end
  
  def add_details item, qty, val
    item_detail = self.transaction_details.build
    item_detail.item_name, item_detail.quantity, item_detail.price= item, qty, val
  end
  
  def refund_transaction
    charge = Stripe::Charge.retrieve confirmation_no
    charge.refund if charge   
    add_details 'Refund', 1, 0-amt  # add refund to transaction details
    save!
  end
  
  def save_transaction order
    if valid?
      # add transaction details      
      (1..order[:cnt].to_i).each do |i| 
        if order['quantity'+i.to_s].to_i > 0 
          add_details order['item'+i.to_s], order['quantity'+i.to_s], order['price'+i.to_s].to_f * order['quantity'+i.to_s].to_i
        end 
      end 
    
      # charge the credit card using Stripe
      if amt > 0.0 then
        result = Stripe::Charge.create(:amount => (amt * 100).to_i, :currency => "usd", :card => token, :description => description)  
      end
      
      if result
        self.confirmation_no, self.payment_type, self.credit_card_no = result.id, result.card[:type], result.card[:last4] 
      else
        self.confirmation_no = Time.now.to_i.to_s   
      end  
      save!  
    end
    
    rescue Stripe::CardError => e
      process_error e
    rescue Stripe::AuthenticationError => e
      process_error e
    rescue Stripe::InvalidRequestError => e
      process_error e
    rescue Stripe::APIConnectionError => e
      process_error e
    rescue Stripe::StripeError => e
      ExceptionNotifier::Notifier.exception_notification('StripeError', e).deliver if Rails.env.production?
      process_error e
    rescue => e
      process_error e
    false
  end
  
  def process_error e
    logger.error "Stripe error while processing this transaction: #{e.message}"
    errors.add :base, "There was a problem with your credit card. #{e.message}"    
  end
  
  def check_for_stripe_error
    self.errors[:credit_card_no] = @stripe_error
  end
end
