class OysterCard
  attr_accessor :balance

  def initialize
    @balance = 5.00
  end

  def top_up(amount)
    if amount.is_a?(Integer) || amount.is_a?(Float)
      @balance += amount.abs
    elsif !amount.is_a?(Integer) || !amount.is_a?(Float)
      raise 'You must enter a number to top up your card!'
    end
=begin
    elsif amount * -1 == amount.abs
      raise 'The number must be positive!'
    end
=end      
    
  end
end