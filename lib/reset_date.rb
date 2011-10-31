module ResetDate

  def reset_dates(val)
    val[:eventstarttime] = val[:"eventstarttime(5i)"]
    val.delete(:"eventstarttime(5i)")
    val[:eventendtime] = val[:"eventendtime(5i)"]
    val.delete(:"eventendtime(5i)")
    val
  end
end
