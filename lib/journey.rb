class Journey
  @@history = []

  attr_reader :current_journey

  def initialize
    @current_journey = {entry_station: nil, entry_station: nil}
  end

  def self.history
    @@history
  end

  def start(station)
    @current_journey[:entry_station] = station
  end
end