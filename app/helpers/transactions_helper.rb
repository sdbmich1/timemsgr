module TransactionsHelper

  # calculates item price
  def calc_price price, amt
    sum = price.to_f * amt.to_i 
    @total += sum
    sum
  end
  
  def set_qty fldname
    if @order
      @order[fldname] ? @order[fldname].to_i : 0
    else
      0
    end
  end
  
  def get_descr
    'A ' + get_discount + ' discount will be applied at checkout.' if @discount
  end
  
  def calc_discount
    if @discount
      @discount.amountOff ? 0 - @discount.amountOff : @discount.percentOff ? @total * (@discount.percentOff/-100.0) : 0
    else
      0
    end
  end
  
  def get_discount
    if @discount
      @discount.amountOff ? '$'+ @discount.amountOff.to_s : @discount.percentOff.to_s + '%'
    else
      'N/A'
    end
  end
  
  def get_ary
    (0..30).inject([]){|x,y| x << y}
  end
  
  def get_fname event, fname, flg
    flg ? fname : event.send(fname)
  end
  
  def get_promo_code
    @discount ? @discount.code : nil
  end
  
  def get_processing_fee 
    @fees = (@total + calc_discount) * (KITS_PERCENT.to_f / 100)
  end
  
  def get_convenience_fee
    KITS_FEE
  end
  
  def grand_total
    @total += @fees + KITS_FEE.to_f + calc_discount
  end
  
  def convenience_fee?
    KITS_FEE.to_f > 0.0
  end
  
  def processing_fee?
    KITS_PERCENT.to_f > 0.0
  end
  
  def refundable? t
    new_dt = t.created_at + 30.days rescue nil
    new_dt ? new_dt > Date.today() : false
  end
  
  def show_title paid
    paid ? 'Total Paid' : 'Total Due'
  end
end
