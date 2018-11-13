require 'json'
require 'date'

input_path = './data/input.json'
serialized_input = File.read(input_path)
input = JSON.parse(serialized_input)
output = []

input['rentals'].each do |rental|
  car = input['cars'].find { |c| c['id'] == rental['car_id'] }
  price = (((Date.parse(rental['end_date']) - Date.parse(rental['start_date'])).to_i + 1) *
    car['price_per_day']) + (rental['distance'] * car['price_per_km'])
  output << { id: rental['id'], price: price }
end

File.open('./data/output.json', 'w') do |f|
  f.write(JSON.pretty_generate(rentals: output))
end
