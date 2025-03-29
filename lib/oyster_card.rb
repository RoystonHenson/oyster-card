class
  OysterCard
    attr_reader :balance, :in_journey, :entry_station

  OPENING_BALANCE = 0
  MIN_FARE = 1
  MAX_BALANCE = 90

  def initialize
    @balance = OPENING_BALANCE
    #@in_journey = false
    @entry_station = nil
  end

  def top_up(amount)
    verify_top_up_amount(amount)
  end

  def touch_in(station)
    @balance >= MIN_FARE ? @entry_station = station : raise('Insufficient balance. Please top up.')
    
  end

  def touch_out
    deduct(MIN_FARE)
    @entry_station = nil
  end

  def in_journey?
    @entry_station
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