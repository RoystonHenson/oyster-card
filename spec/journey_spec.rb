require 'journey'

describe Journey do
  let(:journey)       { Journey.new }
  let(:entry_station) { double(:entry_station)}
  let(:exit_station)  { double(:exit_station)}
  let(:third_station) { double(:third_station)}

  

  describe '#initialize' do
    it 'sets fare to minimum fare' do
      expect(journey.fare).to eq(Journey::MIN_FARE)
    end

    it 'has an entry station' do
      expect(journey).to respond_to(:entry_station)
    end

    it 'entry station should be nil' do
      expect(journey.entry_station).to be_nil
    end

    it 'has an exit station' do
      expect(journey).to respond_to(:exit_station)
    end

    it 'exit station should be nil' do
      expect(journey.exit_station).to be_nil
    end
  end

  describe '#start' do
    it 'sets entry station' do
      journey.start(entry_station)
      expect(journey.entry_station).to eq(entry_station)
    end
  end

  describe '#finish' do
    it 'sets exit station' do
      journey.finish(exit_station)
      expect(journey.exit_station).to eq(exit_station)
    end
  end

  xit 'sets fare to penalty fare' do
    expect { journey.finish(exit_station) rescue nil }.to change { journey.fare }.to eq(Journey::PENALTY_FARE)
  end
end
