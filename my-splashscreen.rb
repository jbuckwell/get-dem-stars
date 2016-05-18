require 'gosu'
require './my-window'

class MySplashScreen < Gosu::Window

  WIDTH = 800
  HEIGHT = 800
  MAPS = ["map1","map2","map3"]

  def initialize
    super HEIGHT, WIDTH
    self.caption = "Get Dem Stars!"

    @chosen_map = MAPS.sample
    @background_image = Gosu::Image.new("data/img/maps/#{@chosen_map}.png", :tileable => true)

    @name

    @font = Gosu::Font.new(20)
    @font_big = Gosu::Font.new(40)

  end

  def update
  end

  def draw
    @font.draw("Enter you name:",
               10,
               10,
               ZOrder::UI,
               1.0,
               1.0,
               0xff_ffff00)
    @background_image.draw(0, 0, ZOrder::Background)
  end

  private

  def button_down(id)
    if  id == Gosu::KbEscape
      close
    else id == Gosu::KbReturn
      MyWindow.new(@chosen_map, @name).show
      close
    end
  end
end
