module Commands
  class Create < Base
    attr_reader :m, :n

    def initialize(command_string, bitmap = nil)
      super(command_string, bitmap)

      @m = command_chars[1]
      @n = command_chars[2]
    end

    def execute!
      raise CommandError.new(command_string, errors) if invalid?

      Array.new(n.to_i) { Array.new(m.to_i, DEFAULT_COLOR) }
    end

    def valid?
      return false if !errors.empty?

      add_error("Bitmap already exists") and return false if !bitmap.to_s.empty?
      add_error("M can't be empty") if m.to_s.empty?
      add_error("N can't be empty") if n.to_s.empty?
      add_error("M has to be a number") if !m.to_s.empty? && !number?(m)
      add_error("N has to be a number") if !n.to_s.empty? && !number?(n)
      add_error("M should be greater than 0 and less than 250") if !m.to_s.empty? && number?(m) && m.to_i <= 0 || m.to_i >= 250
      add_error("N should be greater than 0 and less than 250") if !n.to_s.empty? && number?(n) && n.to_i <= 0 || n.to_i >= 250

      errors.empty?
    end
  end
end
