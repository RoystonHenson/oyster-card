require 'oyster_card'

describe OysterCard do
  let(:oyster_card) { OysterCard.new }

  describe '#initialize' do
    it 'has an opening balance of 0' do
      expect(oyster_card.balance).to eq(0)
    end
  end
end