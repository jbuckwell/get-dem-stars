class MyPlayer
   attr_reader :vel_x, :vel_y, :angle
   def initialize
    @image = Gosu::Image.new("data/img/cube.bmp")
    @beep = Gosu::Sample.new("data/beep.wav")
    @x = @y = @vel_x = @vel_y = @angle = 0.0
    @score = 0
  end

  def warp(x,y)
    @x, @y = x, y
  end

  def up
    if @y < 90
	   @y += 0.0
	else
       @y -= 4.5
	end
  end

  def down
    if @y > 620
	   @y -= 0.0
	else
       @y += 4.5
	end
  end	
  
  def left
    if @x < 100
	   @x += 0.0
	else
       @x -= 4.5
	 end
  end  
  
  def right
    if @x > 700
	   @x -= 0.0
	else
       @x += 4.5
	end
  end

  def accelerate
    @vel_x += Gosu::offset_x(@angle, 0.5)
    @vel_y += Gosu::offset_y(@angle, 0.5)
  end

  def draw
    @image.draw_rot(@x, @y, 1, @angle)
  end

  def score
    @score
  end
  
  def collect_stars(stars)
    if stars.reject! { |star| Gosu::distance(@x,
                                             @y, 
                                             star.x,
                                             star.y) < 35 }
    then
      @score += 1
      @beep.play 
    end
  end
end
