require 'oyster_card'

describe OysterCard do
  let(:oyster_card)   { OysterCard.new }
  let(:entry_station) { double('entry station') }
  let(:exit_station)  { double('exit station') }

  describe '#initialize' do
    it 'has an opening balance of 0' do
      expect(oyster_card.balance).to eq(0)
    end

    it 'has an empty journey history' do
      expect(oyster_card.journey_history).to eq([])
    end

    it 'has no logged entry station' do
      expect(oyster_card.current_journey[:entry_station]).to eq(nil)
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

  describe '#touch_in' do
    context 'when card balance is above minimum for starting a journey' do
      before (:each) do
        oyster_card.top_up(OysterCard::MIN_FARE)
      end

      it 'saves entry station' do
        oyster_card.touch_in(entry_station)
        expect(oyster_card.current_journey[:entry_station]).to eq(entry_station)
      end
    end

    context 'when card balance is below minimum for starting a journey' do
      it 'will throw an error' do
        expect { oyster_card.touch_in(entry_station) }.to raise_error(RuntimeError, 'Insufficient balance. Please top up.')
      end

      it 'will not start the journey' do
        expect { oyster_card.touch_in(entry_station) rescue nil}.not_to change { oyster_card.current_journey }
      end
    end
  end

  describe '#touch_out' do
    before(:each) do
      oyster_card.top_up(OysterCard::MIN_FARE)
      oyster_card.touch_in(entry_station)
    end

    it 'saves exit station' do
      oyster_card.touch_out(exit_station)
      expect(oyster_card.journey_history.last[:exit_station]).to eq(exit_station)
    end

    it 'saves completed journey in journey history' do
      oyster_card.touch_out(exit_station)
      expect(oyster_card.journey_history).to eq([{entry_station: entry_station, exit_station: exit_station}])
    end

    it 'sets entry station back to nil' do
      oyster_card.touch_out(exit_station)
      expect(oyster_card.current_journey[:entry_station]).to eq(nil)
    end

    it 'sets exit station back to nil' do
      oyster_card.touch_out(exit_station)
      expect(oyster_card.current_journey[:exit_station]).to eq(nil)
    end

    it "reduces card balance by £#{OysterCard::MIN_FARE}" do
      expect { oyster_card.touch_out(exit_station) }.to change { oyster_card.balance }.by(-OysterCard::MIN_FARE)
    end
  end

  describe '#in_journey?' do
    before(:each) do
      oyster_card.top_up(OysterCard::MIN_FARE)
    end

    context 'when in journey' do  
      it 'returns true' do
        oyster_card.touch_in(entry_station)
        expect(oyster_card).to be_in_journey
      end
    end

    context 'when not in journey' do
      it 'returns false' do
        oyster_card.touch_in(entry_station)
        oyster_card.touch_out(exit_station)
        expect(oyster_card).not_to be_in_journey
      end
    end
  end
end