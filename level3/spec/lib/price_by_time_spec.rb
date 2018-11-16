require './lib/price_by_time'

RSpec.describe '#price_by_time' do

  let(:price_per_day) { rand(100..1000) }

  context 'over 10 days' do
    let(:number_of_days) { rand(11..1000) }
    let(:price) { price_by_time(number_of_days, price_per_day) }

    it 'renders the expected price' do
      expect(price).to eq(price_per_day * (1 + 3 * 0.9 + 6 * 0.7 + (number_of_days - 10) * 0.5))
    end
  end

  context 'between 5 and 10 days' do
    let(:number_of_days) { rand(5..10) }
    let(:price) { price_by_time(number_of_days, price_per_day) }

    it 'renders the expected price' do
      expect(price).to eq(price_per_day * (1 + 3 * 0.9 + (number_of_days - 4) * 0.7))
    end
  end

  context 'between 2 and 4 days' do
    let(:number_of_days) { rand(2..4) }
    let(:price) { price_by_time(number_of_days, price_per_day) }

    it 'renders the expected price' do
      expect(price).to eq(price_per_day * (1 + (number_of_days - 1) * 0.9))
    end
  end

  context 'for 1 day' do
    let(:price) { price_by_time(1, price_per_day) }

    it 'renders the expected price' do
      expect(price).to eq(price_per_day)
    end
  end

  context 'for 0 day' do
    let(:price) { price_by_time(0, 80) }

    it 'renders 0' do
      expect(price).to eq(0)
    end
  end

  context 'for a negative number of days' do
    let(:price) { price_by_time(-rand(1000), 80) }

    it 'renders 0' do
      expect(price).to eq(0)
    end
  end
end
