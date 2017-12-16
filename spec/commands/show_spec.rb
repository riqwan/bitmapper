require './lib/commands/show'

describe Commands::Show do
  let(:bitmap) { [['O', 'A'], ['B', 'S'], ['D', 'A'], ['O', 'Z']] }

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

        expect(subject.execute!).to eq([['O', 'A'], ['B', 'S'], ['D', 'A'], ['O', 'Z']])
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
