require 'gosu'
require 'minigl'
require 'httparty'
require 'net/http'
require 'uri'
require './my-animal'
require './my-stars'
require './my-timer'
require './my-blocker'

class MyWindow < Gosu::Window

  NAME = ARGV[0] || "Chicken Chaser"
  WIDTH = 800
  HEIGHT = 800
  
  ANIMALS = ["dog","dog2","dog3","cat","cat2","cat3"]
  MAPS = ["map1","map2","map3"]
  
  attr_accessor :moving
  def initialize
    super HEIGHT, WIDTH
    self.caption = "Get Dem Stars!"
    
    @background_image = Gosu::Image.new("data/img/maps/#{MAPS.sample}.png", :tileable => true)    
	@player = MyAnimal.new("dude")
    @player.warp(HEIGHT/ 2, WIDTH/ 2)
	
	@total_score = 0
	
	@npc = MyAnimal.new(ANIMALS.sample)
	@npc.warp((rand * 600) + 100, (rand * 600) + 100)
	
	@blockers = Array.new
	rand(1..5).times { @blockers.push(MyBlocker.new("tree")) }
	@blockers.each do |blocker| 
	  blocker.warp((rand * 600) + 100, (rand * 600) + 100)
	end
	
	@level = 1
	
	@thing_anim = Gosu::Image::load_tiles("data/img/thing.bmp",
														    25,
														    25)
	@star_anim = Gosu::Image::load_tiles("data/img/star.png",
														    25,
														    25)
	@things = [@thing_anim, @star_anim]
	
	@moving = false
	@timer = MyTimer.new 
    @stars = Array.new

    @font = Gosu::Font.new(20)
	@font_big = Gosu::Font.new(40)
	
	@name = NAME
	
    @uri = URI("users.darkone.co.uk/~omnicomplacent/GetDemStars/scores.asp")
  end

  def update
    @moving = false
	
	unless @timer.time >= 60
	   @timer.update
	   @player.collect_stars(@stars)
	   @player.collide(@blockers)
	   @npc.collect_stars(@stars)
	   @blockers.each { |blocker| blocker.collect_stars(@stars) }
	   player_movement
	   
	   if rand(100) < 4 and @stars.size < 25
         @stars.push(MyStar.new(@things.sample))
       end
    end	 
	ai_seek unless @stars.empty? || @timer.time >= 60
  end

  def draw
    @background_image.draw(0, 0, ZOrder::Background)
    @player.draw
	@npc.draw
	@blockers.each { |blocker| blocker.draw }
    @stars.each { |star| star.draw }
    @font.draw("Stars This Round: #{@player.score}  Total Stars: #{@player.score + @total_score}  Time Remaining: #{60 - @timer.time}",
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
	
	@npc = MyAnimal.new(ANIMALS.sample)
	@npc.warp((rand * 600) + 100, (rand * 600) + 100)
	if @player.score <= @npc.score
	   @level = 1
	   @total_score = 0
	   @npc.vel_x = 4.5
	   @npc.vel_y = 3.0
	else
	   @total_score += @player.score
	   @level += 1
	   @npc.vel_x += @level * 0.2
	   @npc.vel_y += @level * 0.2
	end
	
	@player = MyAnimal.new("dude")
	@player.warp(HEIGHT/ 2, WIDTH/ 2)
	
	@stars = Array.new
	@background_image = Gosu::Image.new("data/img/maps/#{MAPS.sample}.png", :tileable => true)
	
	@blockers = Array.new
	rand(1..5).times { @blockers.push(MyBlocker.new("tree")) }
	@blockers.each do |blocker| 
	  blocker.warp((rand * 600) + 100, (rand * 600) + 100)
	end
  end
  
  def game_over
    if @timer.time >= 60 
	  #check whether score is one of the top 5
	  #if yes, write score to yaml file
	  #post/ get request to a webserver using RESTful API
	  #HTTParty?
	  @font.draw("#{@name}, your score is #{@player.score + @total_score}",
	                              (WIDTH/ 2) - 200, 
										 HEIGHT/ 2,
										ZOrder::UI,
                                               1.0,
                                               1.0,
                                       0xff_ffff00)
									   
	  @font.draw("Your opponents score was #{@npc.score}",
	                                     (WIDTH/ 2) - 200, 
										 (HEIGHT/ 2) + 20,
										       ZOrder::UI,
                                                      1.0,
                                                      1.0,
                                              0xff_ffff00)
	  
	  if @player.score > @npc.score
	     @font_big.draw("Congratulations you won!",
		                                  (WIDTH/ 2) - 200, 
										  (HEIGHT/ 2) + 40,
										        ZOrder::UI,
                                                       1.0,
                                                       1.0,
                                               0xff_ffff00)
	  else
	    @font_big.draw("You lose! Good day sir!", 
		                         (WIDTH/ 2) - 200,
								 (HEIGHT/ 2) + 40,
									   ZOrder::UI,
                                              1.0,
                                              1.0,
                                      0xff_ffff00)
									  
		@font.draw("Press U to upload score", 
		                         (WIDTH/ 2) - 200,
								 (HEIGHT/ 2) + 80,
									   ZOrder::UI,
                                              1.0,
                                              1.0,
                                      0xff_ffff00)
		post_scores if Gosu::button_down? Gosu::KbU
	  end
	  @font.draw("Press Enter to start again or ESC to exit", 
	                                        (WIDTH/ 2) - 200, 
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
  
  def post_scores
    absolute_score = @total_score + @player.score
    HTTParty.post(@uri, query: {name: @name, score: @total_score + @player.score} )
  end
  
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
