require './lib/bitmap_editor'

describe BitmapEditor do
  describe '.run' do
    context 'commands are all valid' do
      let!(:success_commands_file_1) { './spec/fixtures/success_commands_1.txt' }
      let!(:success_commands_file_2) { './spec/fixtures/success_commands_2.txt' }
      let!(:success_commands_file_3) { './spec/fixtures/success_commands_3.txt' }

      it 'prints the output' do
        subject = described_class.new

        expect { subject.run(success_commands_file_1) }.to output("OOOOO\nOOZZZ\nAWOOO\nOWOOO\nOWOOO\nOWOOO\n").to_stdout
        expect { subject.run(success_commands_file_2) }.to output("ZOOO\nOOOO\nOOOO\nOOOO\n").to_stdout
        expect { subject.run(success_commands_file_3) }.to output("OOOOOOOOOOOOOOO\nOZZZZZOOOOOOOOO\nOOOOOOOOOOOOOOO\nOOOOOOOOOOOOOOO\nOOOOBOOOOOOOOOO\nOWOOOOOOOOOOOOO\nOOOOOOOOOOOOOOO\nOOOOOOOOOOOOOOO\nOOOOOOOOOOOOOOO\nOOOOOOOOOOOOOOO\nOOOOOOOOOOOOOOO\nOOOOOOOOOOOOOOO\nOOOOOOOOOOOOOOO\nOOOOOOOOOOOOOOO\nOOOOOOOOOOOOOOO\nOOOOOOOOOOOOOOO\n").to_stdout
      end
    end

    context 'commands are not all valid' do
      let!(:failure_commands_file_1) { './spec/fixtures/failure_commands_1.txt' }
      let!(:failure_commands_file_2) { './spec/fixtures/failure_commands_2.txt' }
      let!(:failure_commands_file_3) { './spec/fixtures/failure_commands_3.txt' }

      it 'raises error for a command where validation failed' do
        subject = described_class.new

        expect { subject.run(failure_commands_file_1) }.to raise_error(CommandError)
        expect { subject.run(failure_commands_file_2) }.to raise_error(CommandError)
        expect { subject.run(failure_commands_file_3) }.to raise_error(CommandError)
      end
    end
  end
end