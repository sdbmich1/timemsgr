module SetAssn
     
  def set_associations(assn, num)
    if assn.blank?
      num.times { assn.build }
    else
      (num - assn.count).times { assn.build }
    end
    assn
  end   
end
