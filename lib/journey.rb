class Journey
  @@history = []

  attr_reader :current_journey

  def initialize
    @current_journey = {entry_station: nil, exit_station: nil}
  end

  def self.history
    @@history
  end

  def start(station)
    @current_journey[:entry_station] = station
  end

  def finish(station)
    @current_journey[:exit_station] = station
  end

  def complete?
    @current_journey[:entry_station].nil? == false && @current_journey[:exit_station].nil? == false 
  end
end