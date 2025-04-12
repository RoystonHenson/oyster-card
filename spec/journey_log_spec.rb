require 'journey_log'
require 'journey'

describe JourneyLog do
  let(:log)           { JourneyLog.new(journey_class) }
  let(:journey_class) { class_double(Journey, new: journey )}
  let(:journey)       { instance_double(Journey, start: entry_station, finish: exit_station ) }
  let(:entry_station) { double(:entry_station) }
  let(:exit_station)  { double(:exit_station) } 

  describe '#initialize' do
    it 'injects a journey class' do
      expect(log.journey_class).to eq(journey_class)
    end

    it 'initialise current journey as nil' do
      expect(log.current_journey).to eq(nil)              
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
    it 'saves the current journey to journey history' do
      log.start(entry_station)
      log.finish(exit_station)
      expect(log.history).to eq([journey])
    end

    it 'passes exit station to the journey instance' do
      log.start(entry_station)
      expect(journey).to receive(:finish).with(exit_station)
      log.finish(exit_station)
    end

    it 'clears current journey' do
      log.start(entry_station)
      log.finish(exit_station)
      expect(log.current_journey).to eq(nil)
    end
  end
end