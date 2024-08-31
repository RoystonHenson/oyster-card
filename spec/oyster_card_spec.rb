require 'coveralls'
Coveralls.wear!
require 'oyster_card'

describe OysterCard do
  let(:oyster_card) { OysterCard.new }

  describe '#initialize' do
    it 'has a starting balance of 5' do
    expect(oyster_card.balance).to eq(5)
    end
  end
end