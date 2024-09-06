class Journey
  attr_accessor :current_journey, :journey_history

  def initialize
    @current_journey = {}
    @journey_history = []
  end

  def start(place)
    reset_current_journey
    current_journey[:origin] = place
  end

  def finish(place)
    current_journey[:destination] = place
    journey_history << current_journey
  end

  def complete?
    current_journey[:origin] != nil && current_journey[:destination] != nil
  end

  private

  def reset_current_journey
    @current_journey = {origin: nil, destination: nil}
  end
end