# when called, creates an instance variable as an array containing all the actions and the amounts
# for the driver, the owner, the insurance, the assistance and drivy
class CalculateCommissionsService

  attr_reader :actions, :errors

  def initialize(number_of_days, price, options)
    @price = price
    @number_of_days = number_of_days
    @options = options
    @additional_owner_fee = 0
    @additional_drivy_fee = 0
    @errors = []
  end

  def call
    @errors << 'missing at least one argument' and return unless @price && @number_of_days &&
        @options

    insurance_fee = (@price * 0.3 * 0.5).round
    assistance_fee = @number_of_days * 100
    drivy_fee = @price * 0.3 - (insurance_fee + assistance_fee)

    check_for_options
    render_actions(insurance_fee, assistance_fee, drivy_fee)
  end

  private

  def check_for_options
    @options.each do |option|
      case option
      when 'gps'
        @additional_owner_fee += 500 * @number_of_days
      when 'baby_seat'
        @additional_owner_fee += 200 * @number_of_days
      when 'additional_insurance'
        @additional_drivy_fee += 1000 * @number_of_days
      end
    end
  end

  def render_actions(insurance_fee, assistance_fee, drivy_fee)
    @actions = [
      {
        who: 'driver',
        type: 'debit',
        amount: @price + @additional_drivy_fee + @additional_owner_fee
      },
      {
        who: 'owner',
        type: 'credit',
        amount: (@price * 0.7).round + @additional_owner_fee
      },
      {
        who: 'insurance',
        type: 'credit',
        amount: insurance_fee
      },
      {
        who: 'assistance',
        type: 'credit',
        amount: assistance_fee
      },
      {
        who: 'drivy',
        type: 'credit',
        amount: drivy_fee.round + @additional_drivy_fee
      }
    ]
  end
end
