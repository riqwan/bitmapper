require './lib/commands/base'
require './lib/command_error'

module Commands
  class Show < Base
    def execute!
      raise CommandError.new(command_string, errors) if invalid?

      bitmap.each do |row|
        string = ''

        row.each { |bit| string += bit }

        puts string
      end

      bitmap
    end

    def valid?
      return false if !errors.empty?

      add_error("Bitmap doesn't exist") and return false if bitmap.to_s.empty?

      errors.empty?
    end
  end
end
