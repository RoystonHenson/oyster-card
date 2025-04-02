class Journey
  @@history = []

  attr_reader :current_journey

  def initialize(station)
    @current_journey = {entry_station: station}
  end

  def self.history
    @@history
  end
end