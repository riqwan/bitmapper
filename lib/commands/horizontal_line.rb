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
        if (x1.to_i..x2.to_i).include?(x_index + 1)
          bitmap.find_bit(x_index + 1, y.to_i).set_color(c)
        end
      end

      bitmap
    end

    def valid?
      return false if !errors.empty?

      add_error("Bitmap doesn't exist") and return false if bitmap.to_s.empty?
      add_error("X1 can't be empty") if x1.to_s.empty?
      add_error("X2 can't be empty") if x2.to_s.empty?
      add_error("Y can't be empty") if y.to_s.empty?
      add_error("C can't be empty") if c.to_s.empty?
      add_error("X1 has to be a number") if !x1.to_s.empty? && !number?(x1)
      add_error("X2 has to be a number") if !x2.to_s.empty? && !number?(x2)
      add_error("Y has to be a number") if !y.to_s.empty? && !number?(y)
      add_error("C has to be a string starting from A to Z") if !c.to_s.empty? && !('A'..'Z').include?(c)
      add_error("X1 should be within bitmap width range") if !x1.to_s.empty? && number?(x1) && x1.to_i <= 0 || x1.to_i > bitmap.m
      add_error("X2 should be within bitmap width range") if !x2.to_s.empty? && number?(x2) && x2.to_i <= 0 || x2.to_i > bitmap.m
      add_error("Y should be within bitmap length range") if !y.to_s.empty? && number?(y) && y.to_i <= 0 || y.to_i > bitmap.n

      errors.empty?
    end
  end
end
