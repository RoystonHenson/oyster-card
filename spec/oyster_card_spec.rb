require 'oyster_card'

describe OysterCard do
  let(:oyster_card) { OysterCard.new }

  describe '#initialize' do
    it 'has an opening balance of 0' do
      expect(oyster_card.balance).to eq(0)
    end
  end

  describe '#top_up' do
    it 'adds money to the balance' do
      oyster_card.top_up(1)
      expect(oyster_card.balance).to eq(1)
    end
  end
end