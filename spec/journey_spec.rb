require 'journey'

describe Journey do
  let(:journey) { Journey.new }
  let(:entry_station) { double('entry station')}
  let(:exit_station) { double('exit_station') }

  describe '.history' do
    it 'is initialised as empty' do
      expect(journey.class.history).to eq([])
    end
  end

  describe '#initialize' do
    it 'has unassigned entry station for current journey' do
      expect(journey.current_journey[:entry_station]).to eq(nil)
    end

    it 'has unassigned exit station for current journey' do
      expect(journey.current_journey[:exit_station]).to eq(nil)
    end
  end

  describe '#start' do
    it 'adds entry station to current journey' do
      journey.start(entry_station)
      expect(journey.current_journey[:entry_station]).to eq(entry_station)
    end
  end
end