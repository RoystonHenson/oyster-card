require 'journey'

describe Journey do
  let(:journey) { Journey.new }
  let(:entry_station) { double('entry station')}
  let(:exit_station) { double('exit_station')}

  describe '.history' do
    it 'is initialised as empty' do
      expect(journey.class.history).to eq([])
    end
  end

  describe '#initialize' do
    it 'current journey has an entry station key' do
      expect(journey.current_journey.include?(:entry_station)).to eq(true)
    end
    it 'entry station key is nil' do
      expect(journey.current_journey[:entry_station]).to eq(nil)
    end

    it 'current journey has an exit station key' do
      expect(journey.current_journey.include?(:exit_station)).to eq(true)
    end

    it 'exit station key is nil' do
      expect(journey.current_journey[:exit_station]).to eq(nil)
    end
  end

  describe '#start' do
    it 'saves entry station to current journey' do
      journey.start(entry_station)
      expect(journey.current_journey[:entry_station]).to eq(entry_station)
    end
  end

  describe '#finish' do
    before(:each) do
      Journey.class_variable_set(:@@history, [])
    end

    it 'saves exit station when finishing journey' do
      journey.finish(exit_station)
      expect(Journey.history.last[:exit_station]).to eq(exit_station)
    end

    it 'saves completed journey to journey history' do
      journey.start(entry_station)
      journey.finish(exit_station)
      expect(Journey.history).to eq([{entry_station: entry_station, exit_station: exit_station}])
    end

    it 'clears current journey after saving it to journey history' do
      journey.start(entry_station)
      journey.finish(exit_station)
      expect(journey.current_journey).to eq({entry_station: nil, exit_station: nil})
    end
  end

  describe '#complete?' do
    context 'when in journey' do  
      it 'returns false' do
        journey.start(entry_station)
        expect(journey).not_to be_complete
      end
    end

    context 'when not in journey' do
      it 'returns true' do
        journey.start(entry_station)
        journey.finish(exit_station)
        expect(journey).to be_complete
      end
    end
  end
end