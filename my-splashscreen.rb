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

    @name ||= "Chicken Chaser"
    @input = Gosu::TextInput.new

    @font = Gosu::Font.new(20)
    @font_big = Gosu::Font.new(30)

  end

  def update

    @input.text = @name
    @input = nil
    @input = Gosu::TextInput.new
  end

  def draw
    @font_big.draw("Enter you name:",
               (WIDTH/ 2) - 220,
               (HEIGHT/ 2) + 20,
               ZOrder::UI,
               1.0,
               1.0,
               0xff_ffff00)
    @font_big.draw("#{@name}",
                    (WIDTH/ 2),
                    (HEIGHT/ 2) + 20,
                    ZOrder::UI,
                    1.0,
                    1.0,
                    0xff_ffff00)
    @font_big.draw("Press S to start",
                   (WIDTH/ 2) - 135,
                   (HEIGHT/ 2) + 60,
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
   elsif id == Gosu::KbS
      MyWindow.new(@chosen_map, @name).show
      close
    end
  end
end
