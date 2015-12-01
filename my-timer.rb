require 'gosu'

class MyTimer
  attr_reader :time
  
  def initialize
    @time = 0
	@previous_time = Gosu::milliseconds()
  end
  
  def update
    if (Gosu::milliseconds - @previous_time) / 1000 == 1
			@time += 1
			@previous_time = Gosu::milliseconds()
	end
  end
end