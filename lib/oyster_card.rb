class
  OysterCard
    attr_reader :balance

  OPENING_BALANCE = 0

  def initialize
    @balance = OPENING_BALANCE
  end

  def top_up(amount)
    @balance += 1
  end
end