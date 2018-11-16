require './services/calculate_commissions_service'

RSpec.describe CalculateCommissionsService do

  let!(:number_of_days) { rand(1..10) }
  let!(:price) { rand(1000..10_000) }
  let!(:options) { %w[gps baby_seat additional_insurance] }

  let(:service) { described_class.new(number_of_days, price, options) }

  context 'when not called' do

    it 'does not render actions' do
      expect(service.actions).to be_nil
    end
  end

  context 'when called' do

    context 'when all parameters are passed' do

      context 'when all the options are selected' do

        let(:expected_array) do
          [
            {
              who: 'driver',
              type: 'debit',
              amount: price + number_of_days * 500 + number_of_days * 200 + 1000 * number_of_days
            },
            {
              who: 'owner',
              type: 'credit',
              amount: (price * 0.7).ceil + number_of_days * 500 + number_of_days * 200
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
              amount: ((price * 0.3) - ((price * 0.3 * 0.5).floor + number_of_days * 100)).floor +
                1000 * number_of_days
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

      context 'when only the gps option is selected' do

        let(:options) { %w[gps] }

        let(:expected_array) do
          [
            {
              who: 'driver',
              type: 'debit',
              amount: price + number_of_days * 500
            },
            {
              who: 'owner',
              type: 'credit',
              amount: (price * 0.7).ceil + number_of_days * 500
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

      context 'when only the baby seat option is selected' do 

        let(:options) { %w[baby_seat] }

        let(:expected_array) do
          [
            {
              who: 'driver',
              type: 'debit',
              amount: price + number_of_days * 200
            },
            {
              who: 'owner',
              type: 'credit',
              amount: (price * 0.7).ceil + number_of_days * 200
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

      context 'when only the additional insurance option is selected' do

        let(:options) { %w[additional_insurance] }

        let(:expected_array) do
          [
            {
              who: 'driver',
              type: 'debit',
              amount: price + number_of_days * 1000
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
              amount: ((price * 0.3) - ((price * 0.3 * 0.5).floor + number_of_days * 100)).floor +
                number_of_days * 1000
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

      context 'when no options are selected' do

        let(:options) { [] }

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

    end

    context 'when the number of days is missing' do
      let(:number_of_days) { nil }

      it 'returns an error' do
        service.call
        expect(service.actions).to be_nil
        expect(service.errors).to_not be_empty
      end
    end

    context 'when the options ar missing' do
      let(:options) { nil }

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
