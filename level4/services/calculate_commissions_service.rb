# when called, renders an array with all the actions for the driver, the owner,
# the insurance, the assistance and drivy
class CalculateCommissionsService

  attr_reader :actions, :errors

  def initialize(number_of_days, price)
    @price = price
    @number_of_days = number_of_days
    @errors = ''
  end

  def call
    @errors << 'arguments cannot be nil' and return unless @price && @number_of_days

    insurance_fee = (@price * 0.3 * 0.5).floor
    assistance_fee = @number_of_days * 100
    drivy_fee = @price * 0.3 - (insurance_fee + assistance_fee)

    render_actions(insurance_fee, assistance_fee, drivy_fee)
  end

  private

  def render_actions(insurance_fee, assistance_fee, drivy_fee)
    @actions = [
      {
        who: 'driver',
        type: 'debit',
        amount: @price
      },
      {
        who: 'owner',
        type: 'credit',
        amount: (@price * 0.7).ceil
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
        amount: drivy_fee.floor
      }
    ]
  end
end
