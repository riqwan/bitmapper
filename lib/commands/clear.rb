module Commands
  class Clear < Base
    def execute!
      raise CommandError.new(command_string, errors) if invalid?

      bitmap.reset

      bitmap
    end
  end
end
