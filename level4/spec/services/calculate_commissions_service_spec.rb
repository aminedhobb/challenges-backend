require './services/calculate_commissions_service'

RSpec.describe CalculateCommissionsService do

  let!(:number_of_days) { rand(1..10) }
  let!(:price) { rand(1000..10_000) }

  let(:service) { described_class.new(number_of_days, price) }

  context 'when not called' do

    it 'does not render actions' do
      expect(service.actions).to be_nil
    end
  end

  context 'when called' do

    context 'when all parameters are passed' do

      let(:expected_array) do
        [
          {
            who: 'driver',
            type: 'debit',
            amount: price
          },
          {
            who: 'owner',
            type: 'credit',
            amount: (price * 0.7).ceil 
          },
          {
            who: 'insurance',
            type: 'credit',
            amount: (price * 0.3 * 0.5).floor
          },
          {
            who: 'assistance',
            type: 'credit',
            amount: number_of_days * 100
          },
          {
            who: 'drivy',
            type: 'credit',
            amount: ((price * 0.3) - ((price * 0.3 * 0.5).floor + number_of_days * 100)).floor 
          }
        ]
      end

      let(:credited_amount) do
        expected_array[1][:amount] + expected_array[2][:amount] + expected_array[3][:amount] +
          expected_array[4][:amount]
      end

      it 'does render an action' do
        service.call
        expect(service.actions).to_not be_nil
      end

      it 'renders the expected array' do
        service.call
        expect(service.actions).to eq(expected_array)
      end

      it 'debits as much as it credits' do
        service.call
        expect(service.actions[0][:amount]).to eq(credited_amount)
      end

    end

    context 'when the number of days is missing' do
      let(:number_of_days) { nil }

      it 'returns an error' do
        service.call
        expect(service.actions).to be_nil
        expect(service.errors).to_not be_empty
      end
    end

    context 'when the price is missing' do

      let(:price) { nil }

      it 'returns an error' do
        service.call
        expect(service.actions).to be_nil
        expect(service.errors).to_not be_empty
      end
    end
  end
end
