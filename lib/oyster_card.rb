require_relative 'journey'
require_relative 'station'

class
  OysterCard
    attr_reader :balance, :journey_history, :current_journey, :journey

  OPENING_BALANCE = 0
  MIN_FARE = 1                    
  MAX_BALANCE = 90

  def initialize(journey)
    @balance = OPENING_BALANCE
    @journey = journey
  end

  def top_up(amount)
    verify_top_up_amount(amount)
  end

  def touch_in(station)
    @balance >= MIN_FARE ? @journey.start(station) : raise('Insufficient balance. Please top up.')
  end

  def touch_out(station)
    deduct(MIN_FARE)
    @journey.finish(station)
  end

  def in_journey?
    @current_journey[:entry_station]
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