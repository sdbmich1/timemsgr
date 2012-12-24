class TransactionObserver < ActiveRecord::Observer
  observe Transaction
  
  # send confirmation email
  def after_create transaction 
    if Rails.env.development?
      DelayClassMethod.new("UserMailer", "send_transaction_receipt", :params=>[transaction]).delay.perform
    else
      UserMailer.send_transaction_receipt(transaction).deliver 
    end   
  end
end
