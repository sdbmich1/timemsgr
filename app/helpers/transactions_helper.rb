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
  
  def get_ary
    (0..30).inject([]){|x,y| x << y}
  end
  
  def get_fname event, fname, flg
    flg ? fname : event.send(fname)
  end
  
  def get_processing_fee val
    @fees = val * (KITS_PERCENT.to_f / 100)
  end
  
  def grand_total
    @total + @fees + KITS_FEE.to_f
  end
  
  def convenience_fee?
    KITS_FEE.to_f > 0.0
  end
  
  def processing_fee?
    KITS_PERCENT.to_f > 0.0
  end
end
