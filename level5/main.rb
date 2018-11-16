require 'json'
require 'date'
require './lib/price_by_time'
require './services/calculate_commissions_service'

input_path = './data/input.json'
serialized_input = File.read(input_path)
input = JSON.parse(serialized_input)
output = []

input['rentals'].each do |rental|

  car = input['cars'].find { |c| c['id'] == rental['car_id'] }
  options = input['options'].select { |o| o['rental_id'] == rental['id'] }.
    map! { |option| option['type'] }

  number_of_days = (Date.parse(rental['end_date']) - Date.parse(rental['start_date'])).to_i + 1
  price = price_by_time(number_of_days, car['price_per_day']).round +
    rental['distance'] * car['price_per_km']

  calculate_commissions_service = CalculateCommissionsService.new(number_of_days, price, options)
  calculate_commissions_service.call

  raise calculate_commissions_service.errors unless calculate_commissions_service.errors.empty?

  actions = calculate_commissions_service.actions

  output << {
    id: rental['id'],
    options: options,
    actions: actions
  }

end

File.open('./data/output.json', 'w') do |f|
  f.write(JSON.pretty_generate(rentals: output))
end
