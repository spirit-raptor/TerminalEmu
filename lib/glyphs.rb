# A class that defines how a glyph within the terminal works
# These store the following:
# => A character
# => (x, y) coords
# => Background color
# => Foreground color
# => Whether the glyph is flashing or not 

#!/usr/bin/ruby -w

require 'gosu'

module ColorList
  YELLOW = 0xffffff00
  BROWN  = 0xffbb9900 

  GREEN        = 0xaa00ff00
  BRIGHT_GREEN = 0xff00ff00

  BLUE = 0xff00aaff
  CYAN = 0xff00ffff

  RED    = 0xffff0000
  ORANGE = 0xffff9900


  BLACK = 0xff000000 
  GRAY  = 0xffaaaaaa 
  WHITE = 0xffffffff
end

class Color
  attr_accessor :foreground, :background 
  def initialize(foreground = ColorList::WHITE, background = ColorList::BLACK)
    @foreground = foreground
    @background = background
  end

  # Returns a color with the foreground and background swapped
  def get_inverse
    Color.new(@background, @foreground)
  end

  def swap!
    tmp = @foreground
    @foreground = @background
    @background = tmp
    self
  end
end

class Point < Struct.new(:x, :y)
end

class Glyph
  attr_reader :attributes, :char, :color
  def initialize(point, char, color = Color.new, *attributes)
    @point = point
    @char = char

    @color = color
    
    @attributes = attributes
    # Set these all to false initially
    @flashing = @left_line =  @right_line = @top_line = @bottom_line = @bold = @italic = @dim = false

    # Now set all of the glyphs' attributes
    set_attributes
  end

  def top_line?
    @top_line
  end

  def bottom_line?
    @bottom_line
  end

  def bold?
    @bold
  end

  def italic?
    @italic
  end

  def dim?
    @dim
  end

  def right_line?
    @right_line
  end

  def left_line?
    @left_line
  end

  def flashing?
    @flashing
  end

  def swap_colors
    # If the glyph is flashing this will swap the colors
    @color = Color.new(@color.background, @color.foreground)
  end 
 
  def x
    @point.x
  end

  def y 
    @point.y
  end

  private
  def set_attributes
    @attributes.each do |attribute|
      case attribute
      when :flashing
        @flashing = true
      when :left_line
        @left_line = true
      when :right_line
        @right_line = true
      when :top_line
        @top_line = true
      when :bottom_line
        @bottom_line = true
      when :bold
        @bold = true
      when :italic
        @italic = true
      when :dim
        @dim = true
      else
        puts "Invalid attribute passed to a glyph object: #{ attribute }"
      end
    end
  end
end