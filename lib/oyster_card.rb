class OysterCard
  attr_accessor :balance, :in_journey

  MAX_BALANCE = 90
  MIN_BALANCE = 1

  def initialize
    @balance = 5.00
    @in_journey = false
  end

  def top_up(amount)
    check_max_balance(amount)
    if !is_eligible?(amount)
      raise 'You must enter a number to top up your card!'
    elsif is_eligible?(amount)
      @balance += amount.abs
    end
  end

  def deduct(amount)
    @balance -= amount
  end

  def touch_in
    check_balance
    @touched_in = true
  end

  def touch_out
    @touched_in = false
  end

  def in_journey?
    @touched_in  
  end

  private

  def check_max_balance(amount)
    raise "You cannot exceed £#{MAX_BALANCE} on the card!" if balance + amount.to_f > MAX_BALANCE
  end

  def is_eligible?(amount)
    amount.is_a?(Integer) || amount.is_a?(Float)
  end

  def check_balance
    raise "You must have at least £#{MIN_BALANCE} to enter! Please top up!" if balance < MIN_BALANCE
  end
end