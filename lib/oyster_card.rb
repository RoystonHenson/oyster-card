class
  OysterCard
    attr_reader :balance

  OPENING_BALANCE = 0
  MAX_BALANCE = 90

  def initialize
    @balance = OPENING_BALANCE
  end

  def top_up(amount)
    verify_top_up_amount(amount)
  end

  private

  def verify_top_up_amount(amount)
    @balance + amount <= MAX_BALANCE ? @balance += amount : raise("This transaction would exceed the card limit of #{MAX_BALANCE}. Please top up a smaller amount.")
  end
end