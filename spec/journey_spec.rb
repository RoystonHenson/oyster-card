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
    context 'when the current journey was started correctly' do
      before(:each) do
        journey.start(entry_station)
        journey.finish(exit_station)
      end

      it 'saves exit station when finishing journey' do
        expect(journey.recent_journeys.last[:exit_station]).to eq(exit_station)
      end

      it 'copies current journey to recent journeys before reset' do
        expect(journey.recent_journeys).to eq([{entry_station: entry_station, exit_station: exit_station}])
      end

      it 'clears current journey after saving it to journey history' do
        expect(journey.current_journey).to eq({entry_station: nil, exit_station: nil})
      end
    end

    context 'previous journey was not finished correctly and current journey is finished correctly' do
      it 'saves previous incomplete journey and current journey to recent journeys', :tag => true do
        journey.start(entry_station)
        journey.start(third_station)
        journey.finish(exit_station)
        expect(journey.recent_journeys).to eq([{entry_station: entry_station, exit_station: nil},
                                               {entry_station: third_station, exit_station: exit_station}])
      end
    end

    context 'when the current journey was not started correctly' do
      it 'outputs a warning about penalty fare' do
        expect { journey.finish(exit_station) }.to output(
          "You failed to complete your last journey correctly. "\
          "You will be charged £#{Journey::PENALTY_FARE} for this journey.\n").to_stderr
      end

      it 'sets fare to penalty fare' do
        expect { journey.finish(exit_station) rescue nil }.to change { journey.fare }.to eq(Journey::PENALTY_FARE)
      end

      it 'saves incomplete journey to recent journeys' do
        journey.finish(exit_station)
        expect(journey.recent_journeys).to eq([{entry_station: nil, exit_station: exit_station}])
      end
    end
  end
end
