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
	
	unless @timer.time >= 60
	   @timer.update
	   @player.collect_stars(@stars)
	   @npc.collect_stars(@stars)
	   player_movement
	 end
	 
	ai_seek unless @stars.empty? || @timer.time >= 60

    if rand(100) < 4 and @stars.size < 25 || @timer.time <= 60
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
	
	game_over
  end
  
  def restart
    @timer = MyTimer.new 
	@player = MyAnimal.new("dog")
	@player.warp(HEIGHT/ 2, WIDTH/ 2)
	@npc = MyAnimal.new("dog2")
	@npc.warp((rand * 600) + 100, (rand * 600) + 100)
	@stars = Array.new
  end
  
  def game_over
    if @timer.time >= 60 
	  #check whether score is one of the top 5
	  #if yes, write score to yaml file
	  #post/ get request to a webserver using RESTful API
	  @font.draw("Your score was #{@player.score}",
	                              (WIDTH/ 2) - 100, 
										 HEIGHT/ 2,
										ZOrder::UI,
                                               1.0,
                                               1.0,
                                       0xff_ffff00)
									   
	  @font.draw("Your opponents score was #{@npc.score}",
	                                     (WIDTH/ 2) - 100, 
										 (HEIGHT/ 2) + 20,
										       ZOrder::UI,
                                                      1.0,
                                                      1.0,
                                              0xff_ffff00)
	  
	  if @player.score > @npc.score
	    Gosu::Font.new(40).draw("Congratulations you won!",
		                                  (WIDTH/ 2) - 100, 
										  (HEIGHT/ 2) + 60,
										        ZOrder::UI,
                                                       1.0,
                                                       1.0,
                                               0xff_ffff00)
	  else
	    Gosu::Font.new(40).draw("You lost smelly", 
		                         (WIDTH/ 2) - 100,
								 (HEIGHT/ 2) + 60,
									   ZOrder::UI,
                                              1.0,
                                              1.0,
                                      0xff_ffff00)
	  end
	  @font.draw("Press Enter to start again or ESC to exit", 
	                                        (WIDTH/ 2) - 100, 
										   (HEIGHT/ 2) + 100,
										          ZOrder::UI,
                                                         1.0,
                                                         1.0,
                                                 0xff_ffff00)
												 
	   restart if Gosu::button_down? Gosu::KbReturn
	end
  end
  
  def button_down(id)
    if id == Gosu::KbEscape
      close
    end
  end
  
  private
  
  def ai_seek
    if @stars[0].y >= @npc.y
	   @moving = true
       @npc.down
	   @npc.direction = "down"
    else
	   @moving = true
       @npc.up
	   @npc.direction = "up"
    end
    if @stars[0].x >= @npc.x
	   @moving = true
       @npc.right
	   @npc.direction = "right"
    else
	   @moving = true
       @npc.left
	   @npc.direction = "left"
    end
	stopped?(@npc)
  end
  
  def stopped?(character)
    if @moving == false
	  if  character.direction == "left"
	    character.direction = "stoppped_left"
		
	  elsif character.direction == "right"
	    character.direction = "stopped_right"
		
	  elsif character.direction == "up"
	    character.direction = "stopped_up"
		
	  elsif character.direction == "down"
	    character.direction = "stopped_down"
	  end
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
	stopped?(@player)
  end
end
