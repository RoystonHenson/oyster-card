require 'oyster_card'

describe OysterCard do
  let(:oyster_card) { OysterCard.new }

  describe '#initialize' do
    it 'has a starting balance of 5' do
    expect(oyster_card.balance).to eq(5)
    expect(oyster_card.balance).to be_a(Float)
    end
  end

  describe '#top_up' do
    context 'when balance below max' do
      it 'adds money to the balance' do
        oyster_card.top_up(5)
        expect(oyster_card.balance).to eq(10)
      end

      it 'raises error when not given a number' do
        expect { oyster_card.top_up('a') }.to raise_error(RuntimeError, 'You must enter a number to top up your card!')
      end
    end

    context 'when balance above max' do
      it 'raises error for exceeding max balance' do
        oyster_card.balance = 89
        expect { oyster_card.top_up(1.1) }.to raise_error(RuntimeError, "You cannot exceed £#{OysterCard::MAX_BALANCE} on the card!")
      end
    end
  end
end