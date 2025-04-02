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
      expect(journey.current_journey.key?(:entry_station)).to eq(true)
    end
    it 'entry station key is nil' do
      expect(journey.current_journey[:entry_station]).to eq(nil)
    end

    it 'current journey has an exit station key' do
      expect(journey.current_journey.key?(:exit_station)).to eq(true)
    end

    it 'exit station key is nil' do
      expect(journey.current_journey[:exit_station]).to eq(nil)
    end
  end

  describe '#start' do
    it 'adds entry station to current journey' do
      journey.start(entry_station)
      expect(journey.current_journey[:entry_station]).to eq(entry_station)
    end
  end

  describe '#finish' do
    it 'adds exit stattion to current journey' do
      journey.finish(exit_station)
      expect(journey.current_journey[:exit_station]).to eq(exit_station)
    end
  end
end