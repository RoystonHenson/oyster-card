require_relative 'journey'
require_relative 'station'

class OysterCard
    attr_reader :balance, :journey, :minimum_fare

  OPENING_BALANCE = 0      
  #MIN_FARE = Journey::MIN_FARE  
  MAX_BALANCE = 90

  def initialize(minimum_fare=Journey::MIN_FARE, journey=Journey.new)
    @balance = OPENING_BALANCE
    @minimum_fare = minimum_fare
    @journey = journey
  end

  def top_up(amount)
    verify_top_up_amount(amount)
  end

  def touch_in(station)
    @balance >= @minimum_fare ? @journey.start(station) : raise('Insufficient balance. Please top up.')
  end

  def touch_out(station)
    @journey.finish(station)
    deduct_fare
  end

  private

  def verify_top_up_amount(amount)
    @balance + amount <= MAX_BALANCE ? @balance += amount : raise(
      "This transaction would exceed the card limit of £#{MAX_BALANCE}. "\
      "The maximum you can top up is £#{MAX_BALANCE - @balance}.")
  end

  def deduct_fare
    @balance -= @journey.fare
  end
end