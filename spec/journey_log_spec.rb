require 'journey_log'

describe JourneyLog do
  let(:log) { JourneyLog.new(journey_class) }
  let(:journey_class) { double(Journey, new: entry_station) }#, finish: exit_station ) }
  let(:entry_station) { double(:entry_station)}
  #let(:exit_station)  { double(:exit_station)}

  describe '#initialize' do
    it 'injects the journey class' do
      expect(log.journey_class).to eq(journey_class)
    end
  end

  describe '#start' do
  #  before(:each) do
  #    journey.start(entry_station)
  #  end
    it 'instantiates a new journey' do
      log.start(entry_station)
      expect(journey_class).to have_received(:new).with(entry_station)
    end

    xcontext 'when previous journey was started and finished correctly' do
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
        expect { journey.start(entry_station) }.to change { journey.fare }.to eq(Journey::MIN_FARE)
      end
    end
   
    xcontext 'when entry station is already set to the current station' do
      it 'does not change recent journeys' do
        expect { journey.start(entry_station) rescue nil }.not_to change { journey.recent_journeys }
      end

      it 'raises an error about already being touched in' do
        expect { journey.start(entry_station) }.to raise_error(
          RuntimeError, 'You have already touched in at this station!')
      end
    end

    # User did not complete previous journey correctly
    xcontext 'when previous journey was started but not finished correctly' do
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
          "You will be charged £#{Journey::PENALTY_FARE} for this journey.\n").to_stderr
      end

      it 'sets fare to penalty fare' do
        expect { journey.start(third_station) rescue nil }.to change { journey.fare}.to eq(Journey::PENALTY_FARE)
      end

      it 'saves previously incompleted journey to recent journeys' do
        journey.start(third_station)
        expect(journey.recent_journeys).to eq([{entry_station: entry_station, exit_station: nil}])
      end
    end
  end
end