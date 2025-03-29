class
  OysterCard
    attr_reader :balance, :in_journey

  OPENING_BALANCE = 0
  MIN_FARE = 1
  MAX_BALANCE = 90

  def initialize
    @balance = OPENING_BALANCE
    @in_journey = false
  end

  def top_up(amount)
    verify_top_up_amount(amount)
  end

  def touch_in
    @balance >= MIN_FARE ? @in_journey = true : raise('Insufficient balance. Please top up.')
  end

  def touch_out
    @in_journey = false
    deduct(MIN_FARE)
  end

  def in_journey?
    @in_journey == true
  end

  private

  def verify_top_up_amount(amount)
    @balance + amount <= MAX_BALANCE ? @balance += amount : raise(
      "This transaction would exceed the card limit of £#{MAX_BALANCE}. "\
      "The maximum you can top up is £#{MAX_BALANCE - @balance}.")
  end

  def deduct(fare)
    @balance -= fare
  end
end