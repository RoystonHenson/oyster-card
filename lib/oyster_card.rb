require_relative 'fare_constants'

class OysterCard
  include FareConstants

  attr_reader :balance, :fare, :journey_log

  OPENING_BALANCE = 0      
  MAX_BALANCE = 90

  def initialize(journey_log)
    @balance = OPENING_BALANCE
    @fare = MIN_FARE
    @journey_log = journey_log
  end

  def top_up(amount)
    verify_top_up_amount(amount)
  end

  def touch_in(station)
    @balance >= @fare ? @journey_log.start(station) : raise('Insufficient balance. Please top up.')
  end

  def touch_out(station)
    @journey_log.finish(station)
    deduct_fare
  end

  private

  def verify_top_up_amount(amount)
    @balance + amount <= MAX_BALANCE ? @balance += amount : raise(
      "This transaction would exceed the card limit of £#{MAX_BALANCE}. "\
      "The maximum you can top up is £#{MAX_BALANCE - @balance}.")
  end

  def deduct_fare
    @balance -= @fare
  end
end