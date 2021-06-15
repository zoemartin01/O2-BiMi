module MainHelper
  def rows
    (drinks.size/3.to_f).ceil - 1
  end

  def drink_row(offset)
    Drink.where(enabled: true).limit(3).offset(offset * 3).find_all
  end
end
