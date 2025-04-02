class Journey
  attr_reader :current_journey

  def initialize(station)
    @current_journey = {entry_station: station}
  end
end