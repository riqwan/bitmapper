require './lib/bitmap'
require './lib/bit'
require './lib/command_error'
require './lib/commands/base'
require './lib/commands/show'

describe Commands::Show do
  let(:bitmap) do
    bitmap = Bitmap.create(2, 4)
    bitmap.find_bit(1,1).set_color('O')
    bitmap.find_bit(2,1).set_color('A')
    bitmap.find_bit(1,2).set_color('B')
    bitmap.find_bit(2,2).set_color('S')
    bitmap.find_bit(1,3).set_color('D')
    bitmap.find_bit(2,3).set_color('A')
    bitmap.find_bit(1,4).set_color('O')
    bitmap.find_bit(2,4).set_color('Z')

    bitmap
  end

  describe '.valid?' do
    context 'when the command is valid' do
      it 'returns true the command passed is valid' do
        subject = described_class.new('S', bitmap)

        expect(subject.valid?).to be_truthy
      end
    end

    context 'when the command is invalid' do
      it 'adds an error and returns false when there is an existing bitmap' do
        subject = described_class.new('S', nil)

        expect(subject.valid?).to be_falsy
        expect(subject.errors).to eq(["Bitmap doesn't exist"])
      end
    end
  end

  describe '.execute!' do
    context 'when command is valid' do
      it 'prints bitmap and returns a bitmap' do
        subject = described_class.new('S', bitmap)

        expect { subject.execute! }.to output("\"OA\\nBS\\nDA\\nOZ\\n\"\n").to_stdout
      end
    end

    context 'when command is invalid' do
      it 'raises a CommandError with command string and comma separated errors' do
        subject = described_class.new('S', nil)

        expect { subject.execute! }.to raise_error(CommandError, "S: Bitmap doesn't exist")
      end
    end
  end
end
