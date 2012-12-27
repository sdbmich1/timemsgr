class Transaction < KitsTsdModel
  attr_accessible :code, :description, :amt, :currency, :transaction_date, 
  :channelID, :HostProfileID, :user_id, :status, :hide, :BillingAddr,
  :first_name, :last_name, :City, :State, :PostalCode, :Phone_Home, :token,
  :Phone_Work, :payment_type,  :Address2, :confirmation_no, :email, :expiration_date, :Country
  
  attr_accessor :cvv, :credit_card_no
  
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
    new_transaction = usr.profile.transactions.build usr.profile.attributes
    new_transaction.user_id = usr.id
    new_transaction.first_name = usr.first_name
    new_transaction.last_name = usr.last_name
    new_transaction.email = usr.email
    new_transaction.BillingAddr = usr.profile.Address1
#    new_transaction.HostProfileID = usr.profile.id
    new_transaction
  end
  
  def save_transaction order
    if valid?
      (1..order[:cnt].to_i).each do |i| 
        if order['quantity'+i.to_s].to_i > 0 
          item_detail = self.transaction_details.build
          item_detail.item_name = order['item'+i.to_s]
          item_detail.quantity = order['quantity'+i.to_s] 
          item_detail.price = order['price'+i.to_s].to_f * order['quantity'+i.to_s].to_i
        end 
      end 
    
      self.confirmation_no = Stripe::Charge.create(
        :amount => (amt * 100).to_i, # amount in cents, again
        :currency => "usd",
        :card => token,
        :description => description).id     
      save!  
    end
    
    rescue Stripe::InvalidRequestError => e
      logger.error "Stripe error while processing this transaction: #{e.message}"
      errors.add :base, "There was a problem with your credit card."
  end
end
