module Commands
  class Base
    # Constants
    DEFAULT_COLOR = 'O'

    attr_reader :command_string, :command, :bitmap, :command_chars
    attr_accessor :errors

    def initialize(command_string, bitmap = nil)
      @command_string = command_string
      @command_chars = command_string.split(' ')
      @command = command_chars[0]
      @bitmap = bitmap
      @errors = []
    end

    def invalid?
      !valid?
    end

    private

    def number?(string)
      string.to_i.to_s == string
    end

    def add_error(error_message)
      errors.push(error_message)
    end
  end
end
