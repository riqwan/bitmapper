module Commands
  class Base
    attr_reader :command_string, :command, :bitmap, :command_chars
    attr_accessor :errors

    def initialize(command_string, bitmap = nil)
      @command_string = command_string
      @command_chars = command_string.split(' ')
      @command = command_chars[0]
      @bitmap = bitmap
      @errors = []
    end

    def valid?
      return false if !errors.empty?

      add_error("Bitmap doesn't exist") and return false if bitmap.to_s.empty?

      errors.empty?
    end

    def invalid?
      !valid?
    end

    private

    # Ideally should be a utils method or a method on string
    def number?(string)
      string.to_i.to_s == string
    end

    def add_error(error_message)
      errors.push(error_message)
    end

    def validates_presence_for(array)
      array.each do |parameter|
        add_error("#{parameter.to_s.upcase} can't be empty") if instance_eval("#{parameter}.to_s.empty?")
      end
    end

    def validates_numericality_for(array)
      array.each do |parameter|
        if instance_eval("!#{parameter}.to_s.empty? && !number?(#{parameter})")
          add_error("#{parameter.to_s.upcase} has to be a number")
        end
      end
    end

    def validates_alphabetical_range_for(array)
      array.each do |parameter|
        color = instance_eval("#{parameter}.to_s")

        if !color.to_s.empty? && !('A'..'Z').include?(color)
          add_error("#{parameter.to_s.upcase} has to be a string starting from A to Z")
        end
      end
    end

    def validates_bitmap_range_for(array, limit)
      array.each do |parameter|
        value = instance_eval("#{parameter}.to_s")

        if !value.empty? && number?(value) && value.to_i <= 0 || value.to_i > limit
          add_error("#{parameter.to_s.upcase} should be within bitmap range")
        end
      end
    end

    def validates_bitmap_range_limit_for(array)
      array.each do |parameter|
        value = instance_eval("#{parameter}.to_s")

        if !value.empty? && number?(value) && value.to_i <= 0 || value.to_i > 250
          add_error("#{parameter.to_s.upcase} should be greater than 0 and less than or equal to 250")
        end
      end
    end
  end
end
