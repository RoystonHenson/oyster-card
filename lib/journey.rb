class Journey
  attr_accessor :current_journey, :journey_history, :fare

  MINIMUM_FARE = 1
  PENALTY_FARE = 6

  def initialize(fare=MINIMUM_FARE)
    @current_journey = {}
    @journey_history = []
  end

  def start(place)
    complete? ? reset_current_journey : calculate_fare
    current_journey[:origin] = place
  end

  def finish(place)
    current_journey[:destination] = place
    journey_history << current_journey
    calculate_fare
  end

  def complete?
    current_journey[:origin] != nil && current_journey[:destination] != nil
  end

  def calculate_fare
    complete? ? @fare = MINIMUM_FARE : @fare = PENALTY_FARE
  end

  private

  def reset_current_journey
    @current_journey = {origin: nil, destination: nil}
  end
end