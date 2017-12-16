class CommandError < StandardError
  def initialize(command_string, errors)
    super("#{command_string}: #{errors.join(', ')}")
  end
end
