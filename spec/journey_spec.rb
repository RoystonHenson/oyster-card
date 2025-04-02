require 'journey'

describe Journey do
  let(:station) { double('entry station')}
  let(:journey) { Journey.new(station) }

  describe '#initialize' do
    it 'sets entry station on instantiation' do
      expect(journey.current_journey[:entry_station]).to eq(station)
    end
  end
end