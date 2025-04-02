require 'journey'

describe Journey do
  let(:station) { double('entry station')}
  let(:journey) { Journey.new(station) }

  describe '.history' do
    it 'is initialised as empty' do
      expect(journey.class.history).to eq([])
    end
  end

  describe '#initialize' do
    it 'sets entry station on instantiation' do
      expect(journey.current_journey[:entry_station]).to eq(station)
    end
  end
end