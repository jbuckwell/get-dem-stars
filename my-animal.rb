class MyAnimal
   attr_accessor :direction, :x, :y, :vel_x, :vel_y
   def initialize(animal)
    @image = Gosu::Image.load_tiles("data/img/animals/#{animal}.bmp", 32, 32)
	@anim_up = @image[9..11]
	@anim_left = @image[3..5]
	@anim_right = @image[6..8]
	@anim_down = @image[0..2]
	@beep = Gosu::Sample.new("data/beep.wav")
    @x = @y = 0.0 
	@vel_x = 4.5
	@vel_y = 3.0
	@score = 0
	@direction = "down"
  end

  def warp(x,y)
    @x, @y = x, y
  end

  def up
    if @y < 65
	   @y += 0.0
	else
       @y -= @vel_y
	end
  end

  def down
    if @y > 670
	   @y -= 0.0
	else
       @y += @vel_y
	end
  end	
  
  def left
    if @x < 80
	   @x += 0.0
	else
       @x -= @vel_x
	 end
  end  
  
  def right
    if @x > 690
	   @x -= 0.0
	else
       @x += @vel_x
	end
  end

  def accelerate
    @vel_x += Gosu::offset_x(@angle, 0.5)
    @vel_y += Gosu::offset_y(@angle, 0.5)
  end
  
  def draw
	movement
  end

  def score
    @score
  end
  
  def collect_stars(stars)
    if stars.reject! { |star| Gosu::distance(@x,
                                             @y, 
                                             star.x,
                                             star.y) < 30 }
      @score += 1
      @beep.play 
    end
  end
  
  def collide(blockers)
    if blockers.each { |blocker| Gosu::distance(@x,
												@y,
												blocker.x,
												blocker.y) < 10 }
	  @score += 1
	end
  end
  
  private
  def movement
    if    direction == "up"
	  anim = @anim_up[Gosu::milliseconds / 100 % @anim_up.size]
	  anim.draw(@x,@y,1)
	elsif direction == "down"
	  anim = @anim_down[Gosu::milliseconds / 100 % @anim_down.size]
	  anim.draw(@x,@y,1)
	elsif direction == "left"
	  anim = @anim_left[Gosu::milliseconds / 100 % @anim_left.size]
	  anim.draw(@x,@y,1)
	elsif direction == "right"
	  anim = @anim_right[Gosu::milliseconds / 100 % @anim_right.size]
	  anim.draw(@x,@y,1)
	elsif direction == "stopped_up"
      @image[9].draw(@x,@y,1)
	elsif direction == "stopped_down"
      @image[0].draw(@x,@y,1)
	elsif direction == "stopped_right"
      @image[6].draw(@x,@y,1)
	else direction == "stopped_left"
      @image[3].draw(@x,@y,1)
	end
  end
end
