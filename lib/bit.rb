class Bit
  attr_reader :x, :y, :c

  def initialize(x, y, c)
    @x = x
    @y = y
    @c = c
  end

  def set_color(c)
    @c = c
  end

  def to_s
    c
  end
end
