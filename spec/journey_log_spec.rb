require 'journey_log'

describe JourneyLog do
  let(:log)           { JourneyLog.new(journey_class) }
  let(:journey_class) { double(Journey, new: entry_station) }#, finish: exit_station ) }
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
    it 'injects the journey class' do
      expect(log.journey_class).to eq(journey_class)
    end

    it 'current journey has an entry station key' do
      expect(log.current_journey.include?(:entry_station)).to eq(true)
    end

    it 'current journey has an exit station key' do
      expect(log.current_journey.include?(:exit_station)).to eq(true)
    end

    it 'entry and exit stations in current journey are both set to nil' do
      expect(log.current_journey).to eq({entry_station: nil, exit_station: nil})
    end
    
    it 'has an array to store completed journey history' do
      expect(log.history).to eq([])
    end

    it 'sets recent journeys to empty array' do
      expect(log.recent_journeys).to eq([])
    end
  end

  describe '#start' do
    before(:each) do
      log.start(entry_station)
    end

    it 'instantiates a new journey object' do
      expect(journey_class).to have_received(:new).with(entry_station)
    end

    context 'when previous journey was started and finished correctly' do
      it 'resets recent journeys to an empty array when starting a new journey' do
        log.finish(exit_station)
        log.start(entry_station)
        expect(log.recent_journeys).to eq([])
      end

      it 'saves entry station to current journey' do
        expect(log.current_journey[:entry_station]).to eq(entry_station)
      end
    end
   
    context 'when entry station is already set to the current station' do
      it 'does not change recent journeys' do
        expect { log.start(entry_station) rescue nil }.not_to change { log.recent_journeys }
      end

      it 'raises an error about already being touched in' do
        expect { log.start(entry_station) }.to raise_error(
          RuntimeError, 'You have already touched in at this station!')
      end
    end

    # User did not complete previous journey correctly
    context 'when previous journey was started but not finished correctly' do
      it 'saves previous incomplete journey to history' do
        log.start(third_station)
        expect(log.history).to eq([{entry_station: entry_station, exit_station: nil}])
      end

      it 'saves last entry station entered to current journey' do
        log.start(third_station)
        expect(log.current_journey[:entry_station]).to eq(third_station)
      end

      it 'outputs a warning about penalty fare' do
        expect { log.start(third_station) }.to output(
          "You failed to complete your last journey correctly. "\
          "You will be charged £#{Journey::PENALTY_FARE} for this journey.\n").to_stderr
      end

      it 'saves previously incompleted journey to history' do
        log.start(third_station)
        expect(log.history).to eq([{entry_station: entry_station, exit_station: nil}])
      end
    end
  end

  describe '#finish' do
    context 'when the current journey was completed correctly' do
      before(:each) do
        log.start(entry_station)
        log.finish(exit_station)
      end

      it 'saves the finished journey to history' do
        expect(log.history).to eq([{entry_station: entry_station, exit_station: exit_station}])
      end

      it 'clears current journey after saving it to journey history' do
        expect(log.current_journey).to eq({entry_station: nil, exit_station: nil})
      end
    end

    context 'previous journey was not finished correctly and current journey is finished correctly' do
      it 'saves previous incomplete journey and current journey to recent journeys', :tag => true do
        log.start(entry_station)
        log.start(third_station)
        log.finish(exit_station)
        expect(log.history).to eq([{entry_station: entry_station, exit_station: nil},
                                               {entry_station: third_station, exit_station: exit_station}])
      end
    end

    context 'when the current journey was not started correctly' do
      it 'outputs a warning about penalty fare' do
        expect { log.finish(exit_station) }.to output(
          "You failed to complete your last journey correctly. "\
          "You will be charged £#{Journey::PENALTY_FARE} for this journey.\n").to_stderr
      end
    end

      it 'saves incomplete journey to history' do
        log.finish(exit_station)
        expect(log.history).to eq([{entry_station: nil, exit_station: exit_station}])
      end
    end
end