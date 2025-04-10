require_relative 'journey'

class JourneyLog
  attr_reader :journey_class

  def initialize(journey_class)
    @journey_class = journey_class
  end

  def start(station)
    @journey_class.new(station)
  end
end

# starting a journey, ending a journey, returning a list of journeys