require './lib/bitmap'
require './lib/bit'
require './lib/command_error'
require './lib/commands/base'
require './lib/commands/horizontal_line'

describe Commands::HorizontalLine do
  let(:bitmap) do
    bitmap = Bitmap.create(4, 4)
    bitmap.find_bit(1,1).set_color('O')
    bitmap.find_bit(2,1).set_color('A')
    bitmap.find_bit(3,1).set_color('Q')
    bitmap.find_bit(4,1).set_color('C')
    bitmap.find_bit(1,2).set_color('B')
    bitmap.find_bit(2,2).set_color('C')
    bitmap.find_bit(3,2).set_color('Z')
    bitmap.find_bit(4,2).set_color('D')
    bitmap.find_bit(1,3).set_color('D')
    bitmap.find_bit(2,3).set_color('A')
    bitmap.find_bit(3,3).set_color('T')
    bitmap.find_bit(4,3).set_color('E')
    bitmap.find_bit(1,4).set_color('O')
    bitmap.find_bit(2,4).set_color('Z')
    bitmap.find_bit(3,4).set_color('Q')
    bitmap.find_bit(4,4).set_color('F')

    bitmap
  end

  describe '.valid?' do
    context 'when the command is valid' do
      it 'returns true the command passed is valid' do
        subject = described_class.new('H 1 3 2 X', bitmap)

        expect(subject.valid?).to be_truthy
      end
    end

    context 'when the command is invalid' do
      it "adds an error and returns false when bitmap isn't available" do
        subject = described_class.new('H 1 3 2 X')

        expect(subject.valid?).to be_falsy
        expect(subject.errors).to eq(["Bitmap doesn't exist"])
      end

      it 'adds an error when X1, X2, Y and C are empty' do
        subject = described_class.new('H', bitmap)

        expect(subject.valid?).to be_falsy
        expect(subject.errors).to eq(["X1 can't be empty", "X2 can't be empty", "Y can't be empty", "C can't be empty"])
      end

      it 'adds an error when X2, Y and C are empty' do
        subject = described_class.new('H 1', bitmap)

        expect(subject.valid?).to be_falsy
        expect(subject.errors).to eq(["X2 can't be empty", "Y can't be empty", "C can't be empty"])
      end

      it 'adds an error when Y and C are empty' do
        subject = described_class.new('H 1 3', bitmap)

        expect(subject.valid?).to be_falsy
        expect(subject.errors).to eq(["Y can't be empty", "C can't be empty"])
      end

      it 'adds an error when C is empty' do
        subject = described_class.new('H 1 3 2', bitmap)

        expect(subject.valid?).to be_falsy
        expect(subject.errors).to eq(["C can't be empty"])
      end

      it 'adds an error when C is a number' do
        subject = described_class.new('H 1 3 2 3', bitmap)

        expect(subject.valid?).to be_falsy
        expect(subject.errors).to eq(['C has to be a string starting from A to Z'])
      end

      it 'adds errors when X1 , X2 and Y are not numbers' do
        subject = described_class.new('H P P P X', bitmap)

        expect(subject.valid?).to be_falsy
        expect(subject.errors).to eq(['X1 has to be a number', 'X2 has to be a number', 'Y has to be a number'])
      end

      it 'adds an error when X1 is less than or equal to 0' do
        subject = described_class.new('H 0 3 2 X', bitmap)

        expect(subject.valid?).to be_falsy
        expect(subject.errors).to eq(['X1 should be within bitmap width range'])
      end

      it 'adds an error when X1 is greater than bitmap width range' do
        subject = described_class.new('H 11 3 2 X', bitmap)

        expect(subject.valid?).to be_falsy
        expect(subject.errors).to eq(['X1 should be within bitmap width range'])
      end

      it 'adds an error when X2 is less than or equal to 0' do
        subject = described_class.new('H 1 -1 2 X', bitmap)

        expect(subject.valid?).to be_falsy
        expect(subject.errors).to eq(['X2 should be within bitmap width range'])
      end

      it 'adds an error when X2 is greater than bitmap width range' do
        subject = described_class.new('H 1 5 2 X', bitmap)

        expect(subject.valid?).to be_falsy
        expect(subject.errors).to eq(['X2 should be within bitmap width range'])
      end

      it 'adds an error when Y is greater than bitmap length range' do
        subject = described_class.new('H 1 2 10 X', bitmap)

        expect(subject.valid?).to be_falsy
        expect(subject.errors).to eq(['Y should be within bitmap length range'])
      end

      it 'adds an error when Y is less than or equal to 0' do
        subject = described_class.new('H 1 3 0 X', bitmap)

        expect(subject.valid?).to be_falsy
        expect(subject.errors).to eq(['Y should be within bitmap length range'])
      end
    end
  end

  describe '.execute!' do
    context 'when command is valid' do
      it 'returns a bitmap with O as the default color' do
        subject = described_class.new('H 1 3 2 X', bitmap)

        expect(subject.execute!.to_a).to eq([['O', 'A', 'Q', 'C'], ['X', 'X', 'X', 'D'], ['D', 'A', 'T', 'E'], ['O', 'Z', 'Q', 'F']])
      end
    end

    context 'when command is invalid' do
      it 'raises a CommandError with command string and comma separated errors' do
        subject = described_class.new('H 10 -1 -3 5', bitmap)

        expect { subject.execute! }.to raise_error(CommandError, "H 10 -1 -3 5: C has to be a string starting from A to Z, X1 should be within bitmap width range, X2 should be within bitmap width range, Y should be within bitmap length range")
      end
    end
  end
end
