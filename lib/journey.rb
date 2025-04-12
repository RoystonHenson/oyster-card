require_relative 'fare_constants'

class Journey
  include FareConstants

  attr_reader :current_journey, :fare, :recent_journeys

  def initialize
    @current_journey = {entry_station: nil, exit_station: nil}
    @fare = MIN_FARE
    @recent_journeys = []
  end

  def start(station)
    raise('You have already touched in at this station!') if @current_journey[:entry_station] == station
    if entry_station_unset?
      start_journey(station)
    else
      start_penalty_journey(station)
    end
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
    @fare = MIN_FARE
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
    @fare = PENALTY_FARE
    warn "You failed to complete your last journey correctly. You will be charged £#{PENALTY_FARE} for this journey."
  end

  def save_journey
    @recent_journeys << @current_journey.clone
  end

  def finish_journey(station)
    @current_journey[:exit_station] = station
    save_journey
  end

  def reset_current_journey
    @current_journey = {entry_station: nil, exit_station: nil}
  end
end