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
        if (y1.to_i..y2.to_i).include?(y_index + 1)
          bitmap.find_bit(x.to_i, y_index + 1).set_color(c)
        end
      end

      bitmap
    end

    def valid?
      return false if !errors.empty?

      add_error("Bitmap doesn't exist") and return false if bitmap.to_s.empty?
      add_error("X can't be empty") if x.to_s.empty?
      add_error("Y1 can't be empty") if y1.to_s.empty?
      add_error("Y2 can't be empty") if y2.to_s.empty?
      add_error("C can't be empty") if c.to_s.empty?
      add_error("X has to be a number") if !x.to_s.empty? && !number?(x)
      add_error("Y1 has to be a number") if !y1.to_s.empty? && !number?(y1)
      add_error("Y2 has to be a number") if !y2.to_s.empty? && !number?(y2)
      add_error("C has to be a string starting from A to Z") if !c.to_s.empty? && !('A'..'Z').include?(c)
      add_error("X should be within bitmap width range") if !x.to_s.empty? && number?(x) && x.to_i <= 0 || x.to_i > bitmap.m
      add_error("Y1 should be within bitmap length range") if !y1.to_s.empty? && number?(y1) && y1.to_i <= 0 || y1.to_i > bitmap.n
      add_error("Y2 should be within bitmap length range") if !y2.to_s.empty? && number?(y2) && y2.to_i <= 0 || y2.to_i > bitmap.n

      errors.empty?
    end
  end
end
