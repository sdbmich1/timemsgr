module MapsHelper

  def isPromo? etype
    (%w(channel page).detect { |x| x == etype})
  end
end
