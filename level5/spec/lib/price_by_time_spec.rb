require './lib/price_by_time'

RSpec.describe '#price_by_time' do

  let(:price_per_day) { 80 }

  context 'over 10 days' do
    let(:price) { price_by_time(22, 80) }

    it 'renders the expected price' do
      expect(price).to eq(80 * (1 + 3 * 0.9 + 6 * 0.7 + 12 * 0.5))
    end
  end

  context 'between 5 and 10 days' do
    let(:price) { price_by_time(10, 80) }

    it 'renders the expected price' do
      expect(price).to eq(80 * (1 + 3 * 0.9 + 6 * 0.7))
    end
  end

  context 'between 2 and 4 days' do
    let(:price) { price_by_time(3, 80) }

    it 'renders the expected price' do
      expect(price).to eq(80 * (1 + 2 * 0.9))
    end
  end

  context 'for 1 day' do
    let(:price) { price_by_time(1, 80) }

    it 'renders the expected price' do
      expect(price).to eq(80)
    end
  end

  context 'for 0 day' do
    let(:price) { price_by_time(0, 80) }

    it 'renders 0' do
      expect(price).to eq(0)
    end
  end

  context 'for a negative number of days' do
    let(:price) { price_by_time(-20, 80) }

    it 'renders 0' do
      expect(price).to eq(0)
    end
  end
end
