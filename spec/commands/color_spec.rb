require './lib/commands/color'

describe Commands::Color do
  let(:bitmap) { [['O', 'A', 'Q'], ['B', 'C', 'Z'], ['D', 'A', 'T'], ['O', 'Z', 'Q']] }

  describe '.valid?' do
    context 'when the command is valid' do
      it 'returns true the command passed is valid' do
        subject = described_class.new('L 1 4 A', bitmap)

        expect(subject.valid?).to be_truthy
      end
    end

    context 'when the command is invalid' do
      it "adds an error and returns false when bitmap isn't available" do
        subject = described_class.new('L 1 4 A')

        expect(subject.valid?).to be_falsy
        expect(subject.errors).to eq(["Bitmap doesn't exist"])
      end

      it 'adds an error when X, Y and C are empty' do
        subject = described_class.new('L', bitmap)

        expect(subject.valid?).to be_falsy
        expect(subject.errors).to eq(["X can't be empty", "Y can't be empty", "C can't be empty"])
      end

      it 'adds an error when Y and C are empty' do
        subject = described_class.new('L 1', bitmap)

        expect(subject.valid?).to be_falsy
        expect(subject.errors).to eq(["Y can't be empty", "C can't be empty"])
      end

      it 'adds an error when C is empty' do
        subject = described_class.new('L 1 4', bitmap)

        expect(subject.valid?).to be_falsy
        expect(subject.errors).to eq(["C can't be empty"])
      end

      it 'adds an error when C is a number' do
        subject = described_class.new('L 1 4 5', bitmap)

        expect(subject.valid?).to be_falsy
        expect(subject.errors).to eq(['C has to be a string starting from A to Z'])
      end

      it 'adds errors when N and M are not numbers' do
        subject = described_class.new('L C A R', bitmap)

        expect(subject.valid?).to be_falsy
        expect(subject.errors).to eq(['X has to be a number', 'Y has to be a number'])
      end

      it 'adds an error when X is less than or equal to 0' do
        subject = described_class.new('L 0 4 R', bitmap)

        expect(subject.valid?).to be_falsy
        expect(subject.errors).to eq(['X should be within bitmap width range'])
      end

      it 'adds an error when X is greater than bitmap length range' do
        subject = described_class.new('L 5 4 R', bitmap)

        expect(subject.valid?).to be_falsy
        expect(subject.errors).to eq(['X should be within bitmap width range'])
      end

      it 'adds an error when Y is less than or equal to 0' do
        subject = described_class.new('L 1 0 R', bitmap)

        expect(subject.valid?).to be_falsy
        expect(subject.errors).to eq(['Y should be within bitmap length range'])
      end

      it 'adds an error when Y is greater than bitmap length range' do
        subject = described_class.new('L 1 5 R', bitmap)

        expect(subject.valid?).to be_falsy
        expect(subject.errors).to eq(['Y should be within bitmap length range'])
      end
    end
  end

  describe '.execute!' do
    context 'when command is valid' do
      it 'returns a bitmap with O as the default color' do
        subject = described_class.new('L 1 4 A', bitmap)

        expect(subject.execute!).to eq([['O', 'A', 'Q'], ['B', 'C', 'Z'], ['D', 'A', 'T'], ['A', 'Z', 'Q']])
      end
    end

    context 'when command is invalid' do
      it 'raises a CommandError with command string and comma separated errors' do
        subject = described_class.new('L 0 5 A', bitmap)

        expect { subject.execute! }.to raise_error(CommandError, "L 0 5 A: X should be within bitmap width range, Y should be within bitmap length range")
      end
    end
  end
end
