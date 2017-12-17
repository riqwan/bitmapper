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
      add_error("X can't be empty") if x.to_s.empty?
      add_error("Y can't be empty") if y.to_s.empty?
      add_error("C can't be empty") if c.to_s.empty?
      add_error("X has to be a number") if !x.to_s.empty? && !number?(x)
      add_error("Y has to be a number") if !y.to_s.empty? && !number?(y)
      add_error("C has to be a string starting from A to Z") if !c.to_s.empty? && !('A'..'Z').include?(c)
      add_error("X should be within bitmap width range") if !x.to_s.empty? && number?(x) && x.to_i <= 0 || x.to_i > bitmap.m
      add_error("Y should be within bitmap length range") if !y.to_s.empty? && number?(y) && y.to_i <= 0 || y.to_i > bitmap.n

      errors.empty?
    end
  end
end
