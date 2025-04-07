class Journey
  @@history = []

  MIN_FARE = 1
  PENALTY_FARE = 100

  attr_reader :current_journey, :fare

  def initialize
    @current_journey = {entry_station: nil, exit_station: nil}
    @fare = MIN_FARE
  end

  def self.history
    @@history
  end

  def start(station)
    if entry_station_reset?
      start_journey(station)
    elsif @current_journey[:entry_station] == station
      raise('You have already touched in at this station!')
    else
      apply_penalty
    end
  end

  def finish(station)
    if entry_station_set?
      finish_journey(station)
      reset_current_journey
    else
      apply_penalty
    end
  end

  private

  def reset_current_journey
    @current_journey = {entry_station: nil, exit_station: nil}
  end

  def entry_station_reset?
    @current_journey[:entry_station].nil?
  end

  def start_journey(station)
    @fare = MIN_FARE
    @current_journey[:entry_station] = station 
  end

  def apply_penalty
    @fare = PENALTY_FARE
    warn "You failed to complete your last journey correctly. You will be charged £#{PENALTY_FARE} for this journey."
  end

  def entry_station_set?
    !@current_journey[:entry_station].nil?
  end

  def finish_journey(station)
    @current_journey[:exit_station] = station
    @@history << @current_journey
  end
end