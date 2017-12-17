module Commands
  class Show < Base
    def execute!
      raise CommandError.new(command_string, errors) if invalid?

      puts bitmap.to_s
    end
  end
end
