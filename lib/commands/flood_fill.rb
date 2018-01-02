module Commands
  class FloodFill < Base
    attr_reader :x, :y, :c, :queue

    def initialize(command_string, bitmap = nil)
      super(command_string, bitmap)

      @x = command_chars[1]
      @y = command_chars[2]
      @c = command_chars[3]
      @queue = [[x, y]]
    end

    def execute!
      raise CommandError.new(command_string, errors) if invalid?

      initial_color = bitmap.find_bit(x.to_i, y.to_i).c

      while !queue.empty? do
        x, y = queue.pop
        bit = bitmap.find_bit(x.to_i, y.to_i)

        next if bit.c != initial_color

        bit.set_color(c)
        enqueue_neighbouring_bits(bit)
      end

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

    private

    def enqueue_neighbouring_bits(bit)
      enqueue_bit(bit.x + 1, bit.y)
      enqueue_bit(bit.x, bit.y + 1)
      enqueue_bit(bit.x, bit.y - 1)
      enqueue_bit(bit.x - 1, bit.y)
    end

    def enqueue_bit(a, b)
      if a.to_i > 0 && a.to_i <= bitmap.m && b.to_i > 0 && b.to_i <= bitmap.n
        queue.push([a, b])
      end
    end
  end
end
