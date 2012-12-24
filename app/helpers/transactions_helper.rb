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
end
