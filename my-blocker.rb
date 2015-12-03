class MyBlocker
   attr_accessor :x, :y
   def initialize(object)
    @image = Gosu::Image.new("data/img/#{object}.bmp")
    @x = @y = 0.0
  end

  def warp(x,y)
    @x, @y = x, y
  end
  
  def draw
    @image.draw(@x,@y,1)
  end
  
  def collect_stars(stars)
    if stars.reject! { |star| Gosu::distance(@x,
                                             @y, 
                                             star.x,
                                             star.y) < 30 }
    then

    end
  end
end