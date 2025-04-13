require_relative 'fare_constants'

class Journey
  include FareConstants

  attr_reader :entry_station, :exit_station, :fare
  
  def initialize
    @entry_station = nil
    @exit_station
  end

  def start(station)
    @entry_station = station
    calculate_fare
  end

  def finish(station)
    @exit_station = station
    calculate_fare
  end

  def complete?
    !!@entry_station && !!@exit_station
  end
  
  def calculate_fare
    complete? ? @fare = MIN_FARE : @fare = PENALTY_FARE
  end
end

# refactored, not committed