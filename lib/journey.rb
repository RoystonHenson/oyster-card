class Journey

  MIN_FARE = 1
  PENALTY_FARE = 100

  attr_reader :fare, :entry_station, :exit_station

  def initialize
    @fare = MIN_FARE
    @entry_station = nil
    @exit_station = nil
  end

  def start(station)
    @entry_station = station
    set_fare
  end

  def finish(station)
    @exit_station = station
    set_fare
  end

  def set_fare
    @entry_station && @exit_station ? @fare = MIN_FARE : @fare = PENALTY_FARE
  end

  private

  def apply_penalty_fare
    @fare = PENALTY_FARE
  end

end