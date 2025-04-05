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
    @@history << @current_journey
    reset_current_journey
  end

  def complete?
    @current_journey[:entry_station].nil? == true && @current_journey[:exit_station].nil? == true 
  end

  private
  
  def reset_current_journey
    @current_journey = {entry_station: nil, exit_station: nil}
  end
end