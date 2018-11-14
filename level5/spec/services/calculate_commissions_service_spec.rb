require './services/calculate_commissions_service'

RSpec.describe CalculateCommissionsService do

  let!(:number_of_days) { 3 }
  let!(:price) { 7000 }
  let!(:options) { %w[gps baby_seat additional_insurance] }

  let(:service) { described_class.new(number_of_days, price, options) }

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
            amount: 7000 + 3 * 500 + 3 * 200 + 1000 * 3
          },
          {
            who: 'owner',
            type: 'credit',
            amount: (7000 * 0.7).round + 3 * 500 + 3 * 200
          },
          {
            who: 'insurance',
            type: 'credit',
            amount: (7000 * 0.3 * 0.5).round
          },
          {
            who: 'assistance',
            type: 'credit',
            amount: 3 * 100
          },
          {
            who: 'drivy',
            type: 'credit',
            amount: (7000 * 0.3) + 1000 * 3 - ((7000 * 0.3 * 0.5).round + 3 * 100)
          }
        ]
      end

      it 'does render an action' do
        service.call
        expect(service.actions).to_not be_nil
      end

      it 'renders the expected array' do
        service.call
        expect(service.actions).to eq(expected_array)
      end
    end

    context 'when the number of days is missing' do
      let(:number_of_days) { nil }

      it 'renders an error' do
        service.call
        expect(service.actions).to be_nil
        expect(service.errors).to_not be_empty
      end
    end

    context 'when the options ar missing' do
      let(:options) { nil }

      it 'renders an error' do
        service.call
        expect(service.actions).to be_nil
        expect(service.errors).to_not be_empty
      end
    end

    context 'when the price is missing' do
      let(:price) { nil }

      it 'renders an error' do
        service.call
        expect(service.actions).to be_nil
        expect(service.errors).to_not be_empty
      end
    end

  end
end
