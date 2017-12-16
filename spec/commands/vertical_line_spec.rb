require './lib/command_error'
require './lib/commands/base'
require './lib/commands/vertical_line'

describe Commands::VerticalLine do
  let(:bitmap) { [['O', 'A', 'Q'], ['B', 'C', 'Z'], ['D', 'A', 'T'], ['O', 'Z', 'Q']] }

  describe '.valid?' do
    context 'when the command is valid' do
      it 'returns true the command passed is valid' do
        subject = described_class.new('V 2 1 3 W', bitmap)

        expect(subject.valid?).to be_truthy
      end
    end

    context 'when the command is invalid' do
      it "adds an error and returns false when bitmap isn't available" do
        subject = described_class.new('V 2 1 3 W')

        expect(subject.valid?).to be_falsy
        expect(subject.errors).to eq(["Bitmap doesn't exist"])
      end

      it 'adds an error when X, Y1, Y2 and C are empty' do
        subject = described_class.new('V', bitmap)

        expect(subject.valid?).to be_falsy
        expect(subject.errors).to eq(["X can't be empty", "Y1 can't be empty", "Y2 can't be empty", "C can't be empty"])
      end

      it 'adds an error when Y1, Y2 and C are empty' do
        subject = described_class.new('V 2', bitmap)

        expect(subject.valid?).to be_falsy
        expect(subject.errors).to eq(["Y1 can't be empty", "Y2 can't be empty", "C can't be empty"])
      end

      it 'adds an error when Y2 and C are empty' do
        subject = described_class.new('V 2 1', bitmap)

        expect(subject.valid?).to be_falsy
        expect(subject.errors).to eq(["Y2 can't be empty", "C can't be empty"])
      end

      it 'adds an error when C is empty' do
        subject = described_class.new('V 2 1 3', bitmap)

        expect(subject.valid?).to be_falsy
        expect(subject.errors).to eq(["C can't be empty"])
      end

      it 'adds an error when C is a number' do
        subject = described_class.new('V 2 1 3 9', bitmap)

        expect(subject.valid?).to be_falsy
        expect(subject.errors).to eq(['C has to be a string starting from A to Z'])
      end

      it 'adds errors when X, Y1 and Y2 are not numbers' do
        subject = described_class.new('V M M M C', bitmap)

        expect(subject.valid?).to be_falsy
        expect(subject.errors).to eq(['X has to be a number', 'Y1 has to be a number', 'Y2 has to be a number'])
      end

      it 'adds an error when X is less than or equal to 0' do
        subject = described_class.new('V 0 1 3 C', bitmap)

        expect(subject.valid?).to be_falsy
        expect(subject.errors).to eq(['X should be within bitmap width range'])
      end

      it 'adds an error when X is greater than bitmap length range' do
        subject = described_class.new('V 5 1 3 C', bitmap)

        expect(subject.valid?).to be_falsy
        expect(subject.errors).to eq(['X should be within bitmap width range'])
      end

      it 'adds an error when Y1 is less than or equal to 0' do
        subject = described_class.new('V 2 -1 3 C', bitmap)

        expect(subject.valid?).to be_falsy
        expect(subject.errors).to eq(['Y1 should be within bitmap length range'])
      end

      it 'adds an error when Y1 is greater than bitmap length range' do
        subject = described_class.new('V 2 5 3 C', bitmap)

        expect(subject.valid?).to be_falsy
        expect(subject.errors).to eq(['Y1 should be within bitmap length range'])
      end

      it 'adds an error when Y2 is less than or equal to 0' do
        subject = described_class.new('V 2 1 -3 C', bitmap)

        expect(subject.valid?).to be_falsy
        expect(subject.errors).to eq(['Y2 should be within bitmap length range'])
      end

      it 'adds an error when Y2 is greater than bitmap length range' do
        subject = described_class.new('V 2 1 5 C', bitmap)

        expect(subject.valid?).to be_falsy
        expect(subject.errors).to eq(['Y2 should be within bitmap length range'])
      end
    end
  end

  describe '.execute!' do
    context 'when command is valid' do
      it 'returns a bitmap with O as the default color' do
        subject = described_class.new('V 2 1 3 W', bitmap)

        expect(subject.execute!).to eq([['O', 'W', 'Q'], ['B', 'W', 'Z'], ['D', 'W', 'T'], ['O', 'Z', 'Q']])
      end
    end

    context 'when command is invalid' do
      it 'raises a CommandError with command string and comma separated errors' do
        subject = described_class.new('V 10 -1 -3 5', bitmap)

        expect { subject.execute! }.to raise_error(CommandError, "V 10 -1 -3 5: C has to be a string starting from A to Z, X should be within bitmap width range, Y1 should be within bitmap length range, Y2 should be within bitmap length range")
      end
    end
  end
end
