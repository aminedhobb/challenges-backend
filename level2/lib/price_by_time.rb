def price_by_time(number_of_days, price_per_day)
  case number_of_days
  when (11..Float::INFINITY)
    price_per_day * (1 + 3 * 0.9 + 6 * 0.7 + (number_of_days - 10) * 0.5)
  when (5..10)
    price_per_day * (1 + 3 * 0.9 + (number_of_days - 4) * 0.7)
  when (2..4)
    price_per_day * (1 + (number_of_days - 1) * 0.9)
  when 1
    price_per_day
  else
    0
  end
end
