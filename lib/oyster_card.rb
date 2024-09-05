class OysterCard
  attr_reader :current_journey, :journey_history
  attr_accessor :balance

  STARTING_BALANCE = 5.00
  MAX_BALANCE = 90
  MIN_BALANCE = 1

  def initialize
    @balance = STARTING_BALANCE
    @current_journey = {}
    @journey_history = []
  end

  def top_up(amount)
    check_max_balance(amount)
    eligible?(amount) ? @balance += amount.abs : raise('You must enter a number to top up your card!')
  end

  def touch_in(station_name)
    check_balance
    reset_current_journey
    @current_journey[:entry_station] = station_name
  end

  def touch_out(station_name, fare)
    @current_journey[:exit_station] = station_name
    @journey_history << @current_journey
    deduct(fare)
  end

  private

  def check_max_balance(amount)
    raise "You cannot exceed £#{MAX_BALANCE} on the card!" if balance + amount.to_f > MAX_BALANCE
  end

  def eligible?(amount)
    amount.is_a?(Integer) || amount.is_a?(Float)
  end

  def check_balance
    raise "You must have at least £#{MIN_BALANCE} to enter! Please top up!" if balance < MIN_BALANCE
  end

  def deduct(amount)
    @balance -= amount
  end

  def reset_current_journey
    @current_journey = {entry_station: nil, exit_station: nil}
  end
end