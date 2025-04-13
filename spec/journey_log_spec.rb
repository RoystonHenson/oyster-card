require 'journey_log'
require 'journey'

describe JourneyLog do
  let(:log)           { JourneyLog.new(journey_class) }
  let(:journey_class) { class_double(Journey, new: journey )}
  let(:journey)       { instance_double(Journey, start: entry_station, finish: exit_station, fare: FareConstants::MIN_FARE) }
  let(:entry_station) { double(:entry_station) }
  let(:exit_station)  { double(:exit_station) } 

  describe '#initialize' do
    it 'injects a journey class' do
      expect(log.journey_class).to eq(journey_class)
    end

    it 'initialises current journey as nil' do
      expect(log.current_journey).to eq(nil)              
    end

    it 'initialises fares as an empty array' do
      expect(log.fares).to eq([])
    end

    it 'initialises journey history as an empty array' do
      expect(log.history).to eq([])
    end
  end

  describe '#start' do
    it 'instantiate an instance of the journey class' do
      log.start(entry_station)
      expect(log.current_journey).to eq(journey)
    end

    it 'passes entry station to the journey instance' do
      expect(journey).to receive(:start).with(entry_station)
      log.start(entry_station)
    end
  end

  describe '#finish' do
    before(:each) do
      log.start(entry_station)
    end

    it 'passes exit station to the journey instance' do
      expect(journey).to receive(:finish).with(exit_station)
      log.finish(exit_station)
    end

    it 'saves current journey\'s fare to fares' do
      log.finish(exit_station)
      expect(log.fares.last).to eq(FareConstants::MIN_FARE)
    end

    it 'saves the current journey to journey history' do
      log.finish(exit_station)
      expect(log.history).to eq([journey])
    end

    it 'clears current journey' do
      log.finish(exit_station)
      expect(log.current_journey).to eq(nil)
    end
  end

  describe '#history' do
    it 'returns journey history' do
      expect(log.instance_variable_get(:@history)).to eq(log.history)
    end

    it 'is a copy of history' do
      expect(log.instance_variable_get(:@history)).not_to be(log.history)
    end
  end
end