require 'oyster_card'

describe OysterCard do
  let(:oyster_card) { OysterCard.new }

  describe '#initialize' do
    it 'has an opening balance of 0' do
      expect(oyster_card.balance).to eq(0)
    end

    it 'is not in a journey' do
      expect(oyster_card.in_journey).to eq(false)
    end
  end

  describe '#top_up' do
    context "when card balance remains below £#{OysterCard::MAX_BALANCE} limit" do
      it 'adds money to the balance' do
        expect { oyster_card.top_up(1) }.to change { oyster_card.balance }.by(1)
      end
    end

    context 'when top up will exceed balance limit' do
      it 'will throw an error' do
        expect { oyster_card.top_up(91) }.to raise_error(
          RuntimeError, "This transaction would exceed the card limit of £#{OysterCard::MAX_BALANCE}. "\
          "The maximum you can top up is £#{OysterCard::MAX_BALANCE - oyster_card.balance}.")
      end

      it 'will not add money to the current balance' do
        expect { oyster_card.top_up(91) rescue nil }.not_to change { oyster_card.balance }
      end
    end
  end

  describe '#deduct' do
    it 'subtracts a fare from the card\'s balance' do
      expect { oyster_card.deduct(OysterCard::MIN_FARE) }.to change { oyster_card.balance }.by(-OysterCard::MIN_FARE)
    end
  end

  describe '#touch_in' do
    context 'when card balance is above minimum for starting a journey' do
      it 'touches a card in, beginning a journey' do
        oyster_card.top_up(OysterCard::MIN_FARE)
        oyster_card.touch_in
        expect(oyster_card.in_journey).to eq (true)
      end
    end

    context 'when card balance is below minimum for starting a journey' do
      before(:each) do
        oyster_card.deduct(1)
      end

      it 'will throw an error' do
        expect { oyster_card.touch_in }.to raise_error(RuntimeError, 'Insufficient balance. Please top up.')
      end

      it 'will not start the journey' do
        expect { oyster_card.touch_in rescue nil}.not_to change { oyster_card.in_journey }
      end
    end
  end

  describe '#touch_out' do
    it 'touches a card out, ending a journey' do
      oyster_card.top_up(OysterCard::MIN_FARE)
      oyster_card.touch_in
      oyster_card.touch_out
      expect(oyster_card.in_journey).to eq(false)
    end 
  end

  describe '#in_journey?' do
    before(:each) do
      oyster_card.top_up(OysterCard::MIN_FARE)
    end
    
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