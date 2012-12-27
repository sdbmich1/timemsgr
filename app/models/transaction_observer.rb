class TransactionObserver < ActiveRecord::Observer
  observe Transaction
  
  def before_create transaction
    transaction.currency = 'USD'
    transaction.status = 'active'
    transaction.hide = 'no'
    transaction.transaction_date = Time.now   
  end
  
  # send confirmation email
  def after_create transaction 
#    if Rails.env.development?
#      DelayClassMethod.new("UserMailer", "send_transaction_receipt", :params=>[transaction]).delay.perform
#    else
      UserMailer.send_transaction_receipt(transaction).deliver 
#    end   
  end
end
