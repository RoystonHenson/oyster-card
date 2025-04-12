require 'oyster_card'
require 'journey_log'

describe OysterCard do
  let(:oyster_card)   { OysterCard.new(1, journey_log) }
  let(:journey_log)   { instance_double(JourneyLog,
                                        start: entry_station,
                                        finish: exit_station)}
  let(:entry_station) { double(:entry_station) }
  let(:exit_station)  { double(:exit_station) }

  describe '#initialize' do
    it 'initialises opening balance as 0' do
      expect(oyster_card.balance).to eq(0)
    end

    it 'injects an instance of the journey log class to journey log' do
      expect(oyster_card.journey_log).to eq(journey_log)
    end
    
    it 'initialises minimum_fare when no argument passed in' do
      stub_const('Journey::MIN_FARE', 1)
      expect(oyster_card.minimum_fare).to eq(1)
    end

    it 'initialises minimum_fare when argument passed in' do
      oyster_card = OysterCard.new(5, journey_log)
      expect(oyster_card.minimum_fare).to eq(5)
    end
  end

  describe '#top_up' do
    context "when card balance remains below £#{OysterCard::MAX_BALANCE} limit" do
      it 'adds money to the balance' do
        expect { oyster_card.top_up(1) }.to change { oyster_card.balance }.by(1)
      end
    end

    context 'when top up will exceed balance limit' do
      it 'raises error about exceeding maximum balance' do
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
    context 'when card has sufficient balance to start a journey' do
      it 'passes entry station to journey class' do
        oyster_card.top_up(1)
        expect(journey_log).to receive(:start).with(entry_station)
        oyster_card.touch_in(entry_station)
      end
    end

    context 'when card does not have sufficient balance to start a journey' do
      it 'raises error about needing top up' do
        expect { oyster_card.touch_in(entry_station) }.to raise_error(
          RuntimeError, 'Insufficient balance. Please top up.')
      end
    end
  end

  describe '#touch_out' do
    before(:each) do
      oyster_card.top_up(1)
      oyster_card.touch_in(entry_station)
    end

    it 'passes exit station to journey class' do
      expect(journey_log).to receive(:finish).with(exit_station)
      oyster_card.touch_out(exit_station)
    end

    it "reduces card balance" do
      expect { oyster_card.touch_out(exit_station) }.to change { oyster_card.balance }.by(-1)
    end
  end
end