require 'oyster_card'

describe OysterCard do
  let(:oyster_card) { OysterCard.new }

  describe '#initialize' do
    it 'has an opening balance of 0' do
      expect(oyster_card.balance).to eq(0)
    end

    it 'is not touched in' do
      expect(oyster_card.in_journey).to eq(false)
    end
  end

  describe '#top_up' do
    context 'when card balance remains below balance limit' do
      it 'adds money to the balance' do
        oyster_card.top_up(1)
        expect(oyster_card.balance).to eq(1)
      end
    end

    context 'when top up will exceed balance limit' do
      it 'will throw an error' do
        expect { oyster_card.top_up(91) }.to raise_error(
          RuntimeError, "This transaction would exceed the card limit of #{OysterCard::MAX_BALANCE}. Please top up a smaller amount.")
      end

      it 'will not add money to the current balance' do
        expect { oyster_card.top_up(91) rescue nil }.not_to change { oyster_card.balance }
      end
    end
  end

  describe '#deduct' do
    it 'subtracts a fare from the card\'s balance' do
      fare = 1
      expect { oyster_card.deduct(fare) }.to change { oyster_card.balance }.by(-fare)
    end
  end

  describe '#touch_in' do
    it 'touches a card in' do
      oyster_card.touch_in
      expect(oyster_card.in_journey).to eq (true)
    end
  end

  describe '#touch_out' do
    it 'touches a card out' do
      oyster_card.touch_in
      oyster_card.touch_out
      expect(oyster_card.in_journey).to eq(false)
    end 
  end

  describe '#in_journey?' do
    context 'when in journey' do  
      it 'returns true' do
        oyster_card.touch_in
        expect(oyster_card).to be_in_journey
      end
    end

    context 'when not in journey' do
      it 'returns false' do
        oyster_card.touch_in
        oyster_card.touch_out
        expect(oyster_card).not_to be_in_journey
      end
    end
  end
end