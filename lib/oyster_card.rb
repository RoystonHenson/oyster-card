class OysterCard
  attr_accessor :balance

  MAX_BALANCE = 90

  def initialize
    @balance = 5.00
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

  private

  def check_max_balance(amount)
    raise "You cannot exceed £#{MAX_BALANCE} on the card!" if balance + amount.to_f > MAX_BALANCE
  end

  def is_eligible?(amount)
    amount.is_a?(Integer) || amount.is_a?(Float)
  end
end