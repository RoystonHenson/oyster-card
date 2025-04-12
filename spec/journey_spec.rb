require 'journey'

describe Journey do
  let(:journey)       { Journey.new }
  let(:entry_station) { double(:entry_station)}
  let(:exit_station)  { double(:exit_station)}
  let(:third_station) { double(:third_station)}

  before(:each) do
    @original_stderr = $stderr
    @file = File.open(File::NULL, 'w')
    $stderr = @file
  end

  after(:each) do
    $stderr = @original_stderr
    @file.close
  end

  describe '#initialize' do
    it 'current journey has an entry station key' do
      expect(journey.current_journey.include?(:entry_station)).to eq(true)
    end

    it 'current journey has an exit station key' do
      expect(journey.current_journey.include?(:exit_station)).to eq(true)
    end

    it 'entry and exit stations in current journey are both set to nil' do
      expect(journey.current_journey).to eq({entry_station: nil, exit_station: nil})
    end

    it 'sets fare to minimum fare' do
      expect(journey.fare).to eq(FareConstants::MIN_FARE)
    end

    it 'sets recent journeys to empty array' do
      expect(journey.recent_journeys).to eq([])
    end
  end

  describe '#start' do
    before(:each) do
      journey.start(entry_station)
    end

    context 'when previous journey was started and finished correctly' do
      it 'resets recent journeys to an empty array when starting a new journey' do
        journey.finish(exit_station)
        journey.start(entry_station)
        expect(journey.recent_journeys).to eq([])
      end

      it 'saves entry station to current journey' do
        expect(journey.current_journey[:entry_station]).to eq(entry_station)
      end

      it 'sets fare back to minimum fare after a previous incomplete journey set fare to penalty fare' do
        # Complete the normal journey started in the shared setup (before block)
        journey.finish(exit_station) 

        # Simulate an incomplete journey to trigger penalty fare
        journey.finish(exit_station) 
        expect { journey.start(entry_station) }.to change { journey.fare }.to eq(FareConstants::MIN_FARE)
      end
    end
   
    context 'when entry station is already set to the current station' do
      it 'does not change recent journeys' do
        expect { journey.start(entry_station) rescue nil }.not_to change { journey.recent_journeys }
      end

      it 'raises an error about already being touched in' do
        expect { journey.start(entry_station) }.to raise_error(
          RuntimeError, 'You have already touched in at this station!')
      end
    end

    # User did not complete previous journey correctly
    context 'when previous journey was started but not finished correctly' do
      it 'saves previous incomplete journey to recent journeys' do
        journey.start(third_station)
        expect(journey.recent_journeys).to eq([{entry_station: entry_station, exit_station: nil}])
      end

      it 'saves last entry station entered to current journey' do
        journey.start(third_station)
        expect(journey.current_journey[:entry_station]).to eq(third_station)
      end

      it 'outputs a warning about penalty fare' do
        expect { journey.start(third_station) }.to output(
          "You failed to complete your last journey correctly. "\
          "You will be charged £#{FareConstants::PENALTY_FARE} for this journey.\n").to_stderr
      end

      it 'sets fare to penalty fare' do
        expect { journey.start(third_station) rescue nil }.to change { journey.fare}.to eq(FareConstants::PENALTY_FARE)
      end

      it 'saves previously incompleted journey to recent journeys' do
        journey.start(third_station)
        expect(journey.recent_journeys).to eq([{entry_station: entry_station, exit_station: nil}])
      end
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
          "You will be charged £#{FareConstants::PENALTY_FARE} for this journey.\n").to_stderr
      end

      it 'sets fare to penalty fare' do
        expect { journey.finish(exit_station) rescue nil }.to change { journey.fare }.to eq(FareConstants::PENALTY_FARE)
      end

      it 'saves incomplete journey to recent journeys' do
        journey.finish(exit_station)
        expect(journey.recent_journeys).to eq([{entry_station: nil, exit_station: exit_station}])
      end
    end
  end
end