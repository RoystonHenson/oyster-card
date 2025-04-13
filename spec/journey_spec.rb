require 'journey'

describe Journey do
  let(:journey)       { Journey.new }
  let(:entry_station) { double(:entry_station)}
  let(:exit_station)  { double(:exit_station)}

  describe '#initialize' do
    it 'entry station to be initialized' do
      expect(journey).to respond_to(:entry_station)
    end

    it 'entry stattion to be nil' do
      expect(journey.entry_station).to eq(nil)
    end

    it 'current journey has an exit station key' do
      expect(journey). to respond_to(:exit_station)
    end

    it 'entry and exit stations in current journey are both set to nil' do
      expect(journey.exit_station).to eq(nil)
    end
  end

  describe '#start' do
    before(:each) do
      journey.start(entry_station)
    end

    it 'saves entry station to current journey' do
      expect(journey.entry_station).to eq(entry_station)
    end
  end

  describe '#finish' do
    context 'when the current journey was started correctly' do
      it 'saves exit station when finishing journey' do
        journey.finish(exit_station)
        expect(journey.exit_station).to eq(exit_station)
      end
    end
  end

  describe '#complete?' do
    context 'when journey is complete' do
      it 'returns true' do
        journey.start(entry_station)
        journey.finish(exit_station)
        expect(journey.complete?).to eq(true)
      end
    end

    context 'when journey is not complete' do
      it 'returns false when no exit station' do
        journey.start(entry_station)
        expect(journey.complete?).to eq(false)
      end
      
      it 'returns false when no entry station' do
        journey.finish(exit_station)
        expect(journey.complete?).to eq(false)
      end
    end
  end

  describe '#calculate_fare' do
    context 'when finished journey is complete' do
      it 'sets fare to minimum fare' do
        journey.start(entry_station)
        journey.finish(exit_station)
        expect(journey.fare).to eq(FareConstants::MIN_FARE)
      end
    end

    context 'when finished journey is not complete' do
      it 'sets fare to penalty fare when no exit station' do
        journey.start(entry_station)
        expect(journey.fare).to eq(FareConstants::PENALTY_FARE)
      end

      it 'sets fare to penalty fare when no entry station' do
        journey.finish(exit_station)
        expect(journey.fare).to eq(FareConstants::PENALTY_FARE)
      end
    end
  end
end