require './lib/commands/clear'

describe Commands::Clear do
  let(:bitmap) { [['O', 'A'], ['B', 'C'], ['D', 'A'], ['O', 'Z']] }

  describe '.valid?' do
    context 'when the command is valid' do
      it 'returns true the command passed is valid' do
        subject = described_class.new('C', bitmap)

        expect(subject.valid?).to be_truthy
      end
    end

    context 'when the command is invalid' do
      it 'adds an error and returns false when there is an existing bitmap' do
        subject = described_class.new('C', nil)

        expect(subject.valid?).to be_falsy
        expect(subject.errors).to eq(["Bitmap doesn't exist"])
      end
    end
  end

  describe '.execute!' do
    context 'when command is valid' do
      it 'returns a bitmap with O as the default color' do
        subject = described_class.new('C', bitmap)

        expect(subject.execute!).to eq([['O', 'O'], ['O', 'O'], ['O', 'O'], ['O', 'O']])
      end
    end

    context 'when command is invalid' do
      it 'raises a CommandError with command string and comma separated errors' do
        subject = described_class.new('C', nil)

        expect { subject.execute! }.to raise_error(CommandError, "C: Bitmap doesn't exist")
      end
    end
  end
end
