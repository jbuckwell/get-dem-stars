require 'gosu'

module ZOrder
  Background,Stars,Player,UI = *0..3
end

class MyStar
  attr_accessor :x, :y

  def initialize(animation)
    @animation = animation
    @color = Gosu::Color.new(0xff_000000)
    @color.red = rand(256 - 40) +40
    @color.green = rand(256 - 40) + 40
    @color.blue = rand(256 - 40) + 40
    @x = (rand * 600) + 100
    @y = (rand * 600) + 100
  end

  def draw
    img = @animation[Gosu::milliseconds / 100 % @animation.size]; 
    img.draw(@x - img.width / 2.0, 
             @y - img.height / 2.0,
             ZOrder::Stars, 1, 1, @color, :add)
  end
end
