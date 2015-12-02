require 'gosu'
require 'minigl'
#require './my-player'
require './my-animal'
require './my-stars'
require './my-timer'

class MyWindow < Gosu::Window

  WIDTH = 800
  HEIGHT = 800
  
  attr_accessor :moving
  def initialize
    super HEIGHT, WIDTH
    self.caption = "Get Dem Stars!"
    
    @background_image = Gosu::Image.new("data/img/map1.png", :tileable => true)    
    #@player = MyPlayer.new
	@player = MyAnimal.new("dog")
    @player.warp(HEIGHT/ 2, WIDTH/ 2)
	
	#@x = @y = 20
	
	@npc = MyAnimal.new("dog2")
	@npc.warp((rand * 600) + 100, (rand * 600) + 100)
	
	@moving = false
	
	@timer = MyTimer.new 

    @stars_anim = Gosu::Image::load_tiles("data/img/star.png",
                                          25,
                                          25)
    @stars = Array.new

    @font = Gosu::Font.new(20)
  end

  def update
    @moving = false
    player_movement
	ai_seek unless @stars.empty?

	@timer.update
	if @timer.time >= 60 
	  #check whether score is one of the top 5
	  #if yes, write score to yaml file
	  close
	  puts "Your score was #{@player.score}"
	  puts "Your opponents score was #{@npc.score}"
	  if @player.score > @npc.score
	    puts "Congratulations you won!"
	  else
	    puts "You lost smelly"
	  end
	end
	
    @player.collect_stars(@stars)
	@npc.collect_stars(@stars)

    if rand(100) < 4 and @stars.size < 25 then
      @stars.push(MyStar.new(@stars_anim))
    end
  end

  def draw
    @background_image.draw(0, 0, ZOrder::Background)
    @player.draw
	@npc.draw
    @stars.each { |star| star.draw }
    @font.draw("Stars Ye Have: #{@player.score}   Time Remaining: #{60 - @timer.time}",
                                              10,
                                              10,
                                              ZOrder::UI,
                                              1.0,
                                              1.0,
                                              0xff_ffff00)
	@font.draw("Stars He Have: #{@npc.score}",
	10,
	30,
	ZOrder::UI,
    1.0,
    1.0,
    0xff_ffff00)
  end
  
  def button_down(id)
    if id == Gosu::KbEscape
      close
    end
  end
  
  private
  
  def ai_seek
    if @stars[0].y >= @npc.y
       @npc.down
    else
       @npc.up
    end
    if @stars[0].x >= @npc.x
       @npc.right
    else
       @npc.left
    end
  end
  
  def player_movement
    if Gosu::button_down? Gosu::KbLeft or Gosu::button_down? Gosu::GpLeft  
	  @moving = true
	  @player.left
	  @player.direction = "left"
    end

    if Gosu::button_down? Gosu::KbRight or Gosu::button_down? Gosu::GpRight   
	  @moving = true
	  @player.right
	  @player.direction = "right"
    end

    if Gosu::button_down? Gosu::KbUp or Gosu::button_down? Gosu::GpUp  
	  @moving = true
	  @player.up
	  @player.direction = "up"
    end
	
	if Gosu::button_down? Gosu::KbDown or Gosu::button_down? Gosu::GpDown      
	  @moving = true
	  @player.down
	  @player.direction = "down"
	end
	
	if @moving == false
	  if  @player.direction == "left"
	    @player.direction = "stoppped_left"
		
	  elsif @player.direction == "right"
	    @player.direction = "stopped_right"
		
	  elsif @player.direction == "up"
	    @player.direction = "stopped_up"
		
	  elsif @player.direction == "down"
	    @player.direction = "stopped_down"
	  end
	end
  end
end
