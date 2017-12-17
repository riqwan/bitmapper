module Commands
  class Show < Base
    def execute!
      raise CommandError.new(command_string, errors) if invalid?

      puts bitmap.to_s
    end

    def valid?
      return false if !errors.empty?

      add_error("Bitmap doesn't exist") and return false if bitmap.to_s.empty?

      errors.empty?
    end
  end
end
