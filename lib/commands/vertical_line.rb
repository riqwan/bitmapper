module Commands
  class VerticalLine < Base
    attr_reader :x, :y1, :y2, :c

    def initialize(command_string, bitmap = nil)
      super(command_string, bitmap)

      @x = command_chars[1]
      @y1 = command_chars[2]
      @y2 = command_chars[3]
      @c = command_chars[4]
    end

    def execute!
      raise CommandError.new(command_string, errors) if invalid?

      bitmap.bits.each_with_index do |length, y_index|
        if (y1.to_i..y2.to_i).include?(y_index + 1) || (y2.to_i..y1.to_i).include?(y_index + 1)
          bitmap.find_bit(x.to_i, y_index + 1).set_color(c)
        end
      end

      bitmap
    end

    def valid?
      return false if !errors.empty?

      add_error("Bitmap doesn't exist") and return false if bitmap.to_s.empty?

      validates_presence_for([:x, :y1, :y2, :c])
      validates_numericality_for([:x, :y1, :y2])
      validates_alphabetical_range_for([:c])
      validates_bitmap_range_for([:x], bitmap.m)
      validates_bitmap_range_for([:y1, :y2], bitmap.n)

      errors.empty?
    end
  end
end
