class Transaction < KitsTsdModel
  attr_accessible :code, :description, :amt, :currency, :transaction_date, 
  :channelID, :HostProfileID, :user_id, :status, :hide, :BillingAddr,
  :first_name, :last_name, :City, :State, :PostalCode, :Phone_Home,
  :Phone_Work, :payment_type, :cvv, :credit_card_no, :Address2,
  :confirmation_no, :email, :expiration_date, :Country
  
  belongs_to :user
  
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
                       :length   => { :maximum => 100 },
                       :format => { :with => text_regex }  
  validates :cvv,  :presence => true,
                   :length   => { :maximum => 3 },
                   :numericality => { :only_integer => true }
  validates :credit_card_no,  :presence => true,
                   :length   => { :maximum => 16 },
                   :numericality => { :only_integer => true }
  validates :BillingAddr,  :presence => true,
                       :length   => { :maximum => 50 },
                       :format => { :with => text_regex }  
  validates :Address2, :length   => { :maximum => 50 },
                       :format => { :with => text_regex } 
  validates :Phone_Home, :presence => true
  validates :email, :presence => true, :email_format => true
  validates :expiration_date, :presence => true, :allow_blank => false
  validates :City,  :presence => true,
                       :length   => { :maximum => 50 },
                       :format => { :with => name_regex }  
  validates :State, :presence => true
  validates :Country, :presence => true
  validates :amt, :presence => true, :format => { :with => money_regex }  

end
