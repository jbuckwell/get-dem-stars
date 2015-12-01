require 'gosu'
require './my-player'
require './my-stars'

class MyWindow < Gosu::Window
  def initialize
    super 640, 480
    self.caption = "Gosu Test 1"
    
    #to add an image 
    @background_image = Gosu::Image.new("media/image.png", :tileable => true)    

    @player = MyPlayer.new
    @player.warp(320,420)

    @stars_anim = Gosu::Image::load_tiles("media/star.png",
                                          25,
                                          25)
    @stars = Array.new

    @font = Gosu::Font.new(20)
  end

  def update
    if Gosu::button_down? Gosu::KbLeft or Gosu::button_down? Gosu::GpLeft then @player.turn_left
    end

    if Gosu::button_down? Gosu::KbRight or Gosu::button_down? Gosu::GpRight then @player.turn_right
    end

    if Gosu::button_down? Gosu::KbUp or Gosu::button_down? Gosu::GpUp then @player.accelerate
    end

    @player.move
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
    @font.draw("Stars Ye Have: #{@player.score}",
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

