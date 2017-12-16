require_relative 'command_error'
require_relative 'commands/base'
require_relative 'commands/clear'
require_relative 'commands/color'
require_relative 'commands/create'
require_relative 'commands/horizontal_line'
require_relative 'commands/vertical_line'
require_relative 'commands/show'

class BitmapEditor
  def run(file)
    return puts "please provide correct file" if file.nil? || !File.exists?(file)

    bitmap = nil

    File.open(file).to_a.each do |line|
      command_letter = line.chomp.split(' ').first

      case command_letter
      when 'I', 'C', 'L', 'V', 'H'
        bitmap = command_klass_for(command_letter).new(line, bitmap).execute!
      when 'S'
        command_klass_for(command_letter).new(line, bitmap).execute!
      else
        puts 'unrecognised command :('
      end
    end
  end

  private

  def command_klass_for(command_letter)
    case command_letter
    when 'I'
      Commands::Create
    when 'C'
      Commands::Clear
    when 'L'
      Commands::Color
    when 'V'
      Commands::VerticalLine
    when 'H'
      Commands::HorizontalLine
    when 'S'
      Commands::Show
    end
  end
end
