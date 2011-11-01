module SmartMoney

  def smart_money(column)
    composed_of column,
      :class_name => "Money",
      :mapping => [["#{column}_cents", "cents"], %w(currency currency_as_string)],
      :constructor => Proc.new { |cents, currency| Money.new(cents || 0, currency || Money.default_currency) },
      :converter => Proc.new { |value| value.respond_to?(:to_money) ? convert_money(value) : raise(ArgumentError, "Can't convert #{value.class} to Money") }
  end

  def convert_money(value)
    money = value.to_money
    money.original_value = value
    money
  end
end
