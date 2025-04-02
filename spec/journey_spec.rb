require 'journey'

describe Journey do
  let(:journey) { Journey.new }
  let(:station) { double('entry station')}

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
end