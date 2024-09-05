class OysterCard
  attr_reader :current_journey, :journey_history
  attr_accessor :balance, :entry_station, :exit_station

  STARTING_BALANCE = 5.00
  MAX_BALANCE = 90
  MIN_BALANCE = 1

  def initialize
    @balance = STARTING_BALANCE
    @entry_station = nil
    @exit_station = nil
    @current_journey = []
    @journey_history = []
  end

  def top_up(amount)
    check_max_balance(amount)
    eligible?(amount) ? @balance += amount.abs : raise('You must enter a number to top up your card!')
  end

  def touch_in(station_name)
    check_balance
    @entry_station = station_name
    @exit_station = nil
    @current_journey << @entry_station
  end

  def touch_out(station_name, fare)
    @exit_station = station_name
    @current_journey << @exit_station
    @journey_history << @current_journey
    deduct(fare)
    @entry_station = nil
  end

  def in_journey?
    @entry_station  
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
end