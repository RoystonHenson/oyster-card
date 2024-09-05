require 'station'

describe Station do
  let(:station) { Station.new('Boxwood', 1) }
  
  describe '#initalize' do
    it 'has a name' do
      expect(station.name).to eq('Boxwood')
    end

    it 'has a zone' do
      expect(station.zone).to eq(1)
    end
  end
end