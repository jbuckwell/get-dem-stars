require 'gosu'
require 'minigl'
require './my-player'
require './my-stars'
require './my-timer'

class MyWindow < Gosu::Window
  def initialize
    super 800, 650
    self.caption = "Gosu Test 1"
    
    #to add an image 
    @background_image = Gosu::Image.new("media/map1.png", :tileable => true)    
    #@map = Minigl::Map.new()
    @player = MyPlayer.new
    @player.warp(320,420)
	
	@timer = MyTimer.new 

    @stars_anim = Gosu::Image::load_tiles("media/star.png",
                                          25,
                                          25)
    @stars = Array.new

    @font = Gosu::Font.new(20)
  end

  def update
    if Gosu::button_down? Gosu::KbLeft or Gosu::button_down? Gosu::GpLeft then @player.left
    end

    if Gosu::button_down? Gosu::KbRight or Gosu::button_down? Gosu::GpRight then @player.right
    end

    if Gosu::button_down? Gosu::KbUp or Gosu::button_down? Gosu::GpUp then @player.up
    end
	
	if Gosu::button_down? Gosu::KbDown or Gosu::button_down? Gosu::GpDown then @player.down
	end

	@timer.update
	close if @timer.time >= 120
	
	
    @player.collect_stars(@stars)

    if rand(100) < 4 and @stars.size < 25 then
      @stars.push(MyStar.new(@stars_anim))
    end
  end

  def draw
    #add image
    @background_image.draw(0, 0, ZOrder::Background)
    @player.draw
    @stars.each { |star| star.draw }
    @font.draw("Stars Ye Have: #{@player.score} Time Spent: #{@timer.time}",
                                              10,
                                              10,
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
end

