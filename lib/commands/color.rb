module Commands
  class Color < Base
    attr_reader :x, :y, :c

    def initialize(command_string, bitmap = nil)
      super(command_string, bitmap)

      @x = command_chars[1]
      @y = command_chars[2]
      @c = command_chars[3]
    end

    def execute!
      raise CommandError.new(command_string, errors) if invalid?

      bitmap.find_bit(x.to_i, y.to_i).set_color(c)

      bitmap
    end

    def valid?
      return false if !errors.empty?

      add_error("Bitmap doesn't exist") and return false if bitmap.to_s.empty?

      validates_presence_for([:x, :y, :c])
      validates_numericality_for([:x, :y])
      validates_alphabetical_range_for([:c])
      validates_bitmap_range_for([:x], bitmap.m)
      validates_bitmap_range_for([:y], bitmap.n)

      errors.empty?
    end
  end
end
