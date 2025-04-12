#require_relative 'journey'
#require_relative 'station'

class JourneyLog
  attr_reader :journey_class, :current_journey

  def initialize(journey_class)
    @journey_class = journey_class
    @current_journey = nil
  end

  #starting a journey
  def start(station)
    @current_journey = @journey_class.new
    @current_journey.start(station)
  end
  #ending a journey

  # returning a list of journeys
end