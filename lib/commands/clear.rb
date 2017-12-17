module Commands
  class Clear < Base
    def execute!
      raise CommandError.new(command_string, errors) if invalid?

      bitmap.reset

      bitmap
    end

    def valid?
      return false if !errors.empty?

      add_error("Bitmap doesn't exist") and return false if bitmap.to_s.empty?

      errors.empty?
    end
  end
end
