class OysterCard
  attr_accessor :balance, :entry_station

  MAX_BALANCE = 90
  MIN_BALANCE = 1

  def initialize
    @balance = 5.00
    @entry_station = nil
  end

  def top_up(amount)
    check_max_balance(amount)
    eligible?(amount) ? @balance += amount.abs : raise('You must enter a number to top up your card!')
  end

  def touch_in(station_name)
    check_balance
    @entry_station = station_name
  end

  def touch_out(fare)
    @entry_station = nil
    deduct(fare)
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