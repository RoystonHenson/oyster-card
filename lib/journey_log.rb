#require_relative 'journey'
#require_relative 'station'

class JourneyLog
  attr_reader :journey_class, :current_journey, :history

  def initialize(journey_class)
    @journey_class = journey_class
    @current_journey = nil
    @history = []
  end

  def start(station)
    @current_journey = @journey_class.new
    @current_journey.start(station)
  end

  def finish(station)
    @current_journey.finish(station)
    @history << @current_journey
    @current_journey = nil
  end

  def return_history
    @history
  end
end