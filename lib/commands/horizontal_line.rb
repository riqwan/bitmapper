module Commands
  class HorizontalLine < Base
    attr_reader :x1, :x2, :y, :c

    def initialize(command_string, bitmap = nil)
      super(command_string, bitmap)

      @x1 = command_chars[1]
      @x2 = command_chars[2]
      @y = command_chars[3]
      @c = command_chars[4]
    end

    def execute!
      raise CommandError.new(command_string, errors) if invalid?

      bitmap.bits[y.to_i].each_with_index do |width, x_index|
        if (x1.to_i..x2.to_i).include?(x_index + 1) || (x2.to_i..x1.to_i).include?(x_index + 1)
          bitmap.find_bit(x_index + 1, y.to_i).set_color(c)
        end
      end

      bitmap
    end

    def valid?
      return false if !errors.empty?

      add_error("Bitmap doesn't exist") and return false if bitmap.to_s.empty?

      validates_presence_for([:x1, :x2, :y, :c])
      validates_numericality_for([:x1, :x2, :y])
      validates_alphabetical_range_for([:c])
      validates_bitmap_range_for([:x1, :x2], bitmap.m)
      validates_bitmap_range_for([:y], bitmap.n)

      errors.empty?
    end
  end
end
