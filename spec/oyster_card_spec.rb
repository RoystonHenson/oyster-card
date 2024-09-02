require 'oyster_card'

describe OysterCard do
  let(:oyster_card) { OysterCard.new }
  let(:station) { double('station', name: 'box hill', fare: 2) }

  describe '#initialize' do
    it 'has a starting balance of 5' do
    expect(oyster_card.balance).to eq(5)
    expect(oyster_card.balance).to be_a(Float)
    end

    xit 'has an empty journey history' do
      expect(oyster_card.journey_history).to eq([])
    end
  end

  describe '#top_up' do
    context 'when balance below max balance' do
      it 'adds money to the balance' do
        oyster_card.top_up(5)
        expect(oyster_card.balance).to eq(10)
      end

      it 'raises error when not given a number' do
        expect { oyster_card.top_up('a') }.to raise_error(RuntimeError, 'You must enter a number to top up your card!')
      end
    end

    context 'when balance above max balance' do
      it 'raises error for exceeding max balance' do
        oyster_card.balance = 89
        expect { oyster_card.top_up(1.1) }.to raise_error(RuntimeError, "You cannot exceed £#{OysterCard::MAX_BALANCE} on the card!")
      end
    end
  end

  describe '#touch_in' do
    context 'when the card has sufficient balance' do
      it 'sets the entry station' do
        oyster_card.touch_in(station.name)
        expect(oyster_card.entry_station).to eq(station.name)
      end

    end

    context 'when the card doesn\'t have sufficient balance' do
      it 'raises error for not being above minimum balance' do
        oyster_card.balance = 0.9
        expect { oyster_card.touch_in(station.name) }.to raise_error(RuntimeError, "You must have at least £#{OysterCard::MIN_BALANCE} to enter! Please top up!")
      end
    end
  end

  describe '#touch_out' do
    it 'touches the card out' do
      oyster_card.touch_in(station.name)
      oyster_card.touch_out(station.name, station.fare)
      expect(oyster_card).not_to be_in_journey
    end

    it 'charges the fare to the card' do
      expect { oyster_card.touch_out(station.name, station.fare) }.to change { oyster_card.balance }.by(-station.fare)
    end

    it 'sets the exit station' do
      oyster_card.touch_out(station.name, station.fare)
      expect(oyster_card.exit_station).to eq(station.name)
    end
  end
end