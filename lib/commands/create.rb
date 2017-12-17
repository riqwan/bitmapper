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

      Bitmap.create(m.to_i, n.to_i)
    end

    def valid?
      return false if !errors.empty?

      add_error("Bitmap already exists") and return false if !bitmap.to_s.empty?

      validates_presence_for([:m, :n])
      validates_numericality_for([:m, :n])
      validates_bitmap_range_limit_for([:m, :n])

      errors.empty?
    end
  end
end
