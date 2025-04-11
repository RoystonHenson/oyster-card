require_relative 'journey'
require_relative 'station'

class JourneyLog
  attr_reader :journey_class, :current_journey, :recent_journeys, :history

  def initialize(journey_class)
    @journey_class = journey_class
    @current_journey = {entry_station: nil, exit_station: nil}
    @recent_journeys = []
    @history = []
  end

  def start(station)
    @journey_class.new(station)
    raise('You have already touched in at this station!') if @current_journey[:entry_station] == station
    if entry_station_unset?
      start_journey(station)
    else
      start_penalty_journey(station)
    end
    #@current_journey[:entry_station] = station
  end

  def finish(station)
    apply_penalty_fare if entry_station_unset?
    finish_journey(station)
    reset_current_journey
  end

  private

  def entry_station_unset?
    @current_journey[:entry_station].nil?
  end

  def start_journey(station)
    reset_recent_journeys
    set_entry_station(station)
  end

  def reset_recent_journeys
    @recent_journeys = []
  end

  def set_entry_station(station)
    @current_journey[:entry_station] = station
  end

  def start_penalty_journey(station)
    apply_penalty_fare
    save_journey
    set_entry_station(station)
  end

  def apply_penalty_fare
    warn "You failed to complete your last journey correctly. You will be charged £#{Journey::PENALTY_FARE} for this journey."
  end

  def save_journey
    #@recent_journeys << current_journey.clone # remove recent?
    @history << @current_journey.clone 
  end

  def finish_journey(station)
    @current_journey[:exit_station] = station
    save_journey
  end

  def reset_current_journey
    @current_journey = {entry_station: nil, exit_station: nil}
  end
end