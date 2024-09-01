require 'oyster_card'

describe OysterCard do
  let(:oyster_card) { OysterCard.new }

  describe '#initialize' do
    it 'has a starting balance of 5' do
    expect(oyster_card.balance).to eq(5)
    expect(oyster_card.balance).to be_a(Float)
    end

    it 'is not in journey when new' do
      expect(oyster_card).not_to be_in_journey
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

  describe '#deduct' do
    it 'deducts the fare from the balance' do
      oyster_card.deduct(5)
      expect(oyster_card.balance).to eq(0)
    end
  end

  describe '#touch_in' do
    it 'touches the card in' do
      oyster_card.touch_in
      expect(oyster_card).to be_in_journey
    end
  end

  describe '#touch_out' do
    it 'touches the card out' do
      oyster_card.touch_in
      oyster_card.touch_out
      expect(oyster_card).not_to be_in_journey
    end
  end

  describe '#in_journey?' do
    it 'tells you if it is in journey or not' do
    expect(oyster_card).not_to be_in_journey
    oyster_card.touch_in
    expect(oyster_card).to be_in_journey
    oyster_card.touch_out
    expect(oyster_card).not_to be_in_journey
    end
  end
end