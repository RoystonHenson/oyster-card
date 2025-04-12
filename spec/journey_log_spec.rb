require 'journey_log'
require 'journey'

describe JourneyLog do
  let(:log)           { JourneyLog.new(journey_class) }
  let(:journey_class) { class_double(Journey, new: journey )}
  let(:journey)       { instance_double(Journey, start: station) }
  let(:station)       { double(:station) }

  describe '#initialize' do
    it 'injects a journey class' do
      expect(log.journey_class).to eq(journey_class)
    end

    it 'initialise current journey as an empty array' do
      expect(log.current_journey).to eq(nil)              # UPDATE
    end
  end

  describe '#start' do
    it 'instantiate an instance of the Journey class' do
      log.start(station)
      expect(log.current_journey).to eq(journey)
    end
  end
end