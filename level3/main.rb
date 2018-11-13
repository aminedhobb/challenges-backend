require 'json'
require 'date'
require './lib/price_by_time.rb'

input_path = './data/input.json'
serialized_input = File.read(input_path)
input = JSON.parse(serialized_input)
output = []

input['rentals'].each do |rental|
  car = input['cars'].find { |c| c['id'] == rental['car_id'] }
  number_of_days = (Date.parse(rental['end_date']) - Date.parse(rental['start_date'])).to_i + 1
  price = price_by_time(number_of_days, car['price_per_day']).round +
    rental['distance'] * car['price_per_km']
  insurance_fee = (price * 0.3 * 0.5).round
  assistance_fee = number_of_days * 100
  drivy_fee = price * 0.3 - (insurance_fee + assistance_fee)
  output << { 
    id: rental['id'], 
    price: price, 
    commission: { 
      insurance_fee: insurance_fee,
      assistance_fee: assistance_fee, 
      drivy_fee: drivy_fee.to_i
    }
  }
end

File.open('./data/output.json', 'w') do |f|
  f.write(JSON.pretty_generate(rentals: output))
end
