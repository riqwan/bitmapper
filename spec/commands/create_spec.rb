require './lib/commands/create'

describe Commands::Create do
  describe '.valid?' do
    context 'when the command is valid' do
      it 'returns true the command passed is valid' do
        subject = described_class.new('I 2 3')

        expect(subject.valid?).to be_truthy
      end
    end

    context 'when the command is invalid' do
      it 'adds an error and returns false when there is an existing bitmap' do
        subject = described_class.new('I 2 3', [[1,2,3], [4,5,6]])

        expect(subject.valid?).to be_falsy
        expect(subject.errors).to eq(['Bitmap already exists'])
      end

      it 'adds an error and returns false when M and N are empty' do
        subject = described_class.new('I')

        expect(subject.valid?).to be_falsy
        expect(subject.errors).to eq(["M can't be empty", "N can't be empty"])
      end

      it 'adds an error and returns false when N is empty' do
        subject = described_class.new('I 5')

        expect(subject.valid?).to be_falsy
        expect(subject.errors).to eq(["N can't be empty"])
      end

      it 'adds an error and returns false when M is not a number' do
        subject = described_class.new('I S 3')

        expect(subject.valid?).to be_falsy
        expect(subject.errors).to eq(['M has to be a number'])
      end

      it 'adds an error and returns false when N is not a number' do
        subject = described_class.new('I 2 S')

        expect(subject.valid?).to be_falsy
        expect(subject.errors).to eq(['N has to be a number'])
      end

      it 'adds errors when N and M are not numbers' do
        subject = described_class.new('I T S')

        expect(subject.valid?).to be_falsy
        expect(subject.errors).to eq(['M has to be a number', 'N has to be a number'])
      end

      it 'adds an error and returns false when M is less than or equal to 0' do
        subject = described_class.new('I 0 50')

        expect(subject.valid?).to be_falsy
        expect(subject.errors).to eq(['M should be greater than 0 and less than 250'])
      end

      it 'adds an error and returns false when N is less than or equal to 0' do
        subject = described_class.new('I 50 -40')

        expect(subject.valid?).to be_falsy
        expect(subject.errors).to eq(['N should be greater than 0 and less than 250'])
      end

      it 'adds an error and returns false when M is greater than 250' do
        subject = described_class.new('I 500 50')

        expect(subject.valid?).to be_falsy
        expect(subject.errors).to eq(['M should be greater than 0 and less than 250'])
      end

      it 'adds an error and returns false when N is greater than 250' do
        subject = described_class.new('I 50 340')

        expect(subject.valid?).to be_falsy
        expect(subject.errors).to eq(['N should be greater than 0 and less than 250'])
      end
    end
  end

  describe '.execute!' do
    context 'when command is valid' do
      it 'returns a bitmap with O as the default color' do
        subject = described_class.new('I 2 3')

        expect(subject.execute!).to eq([['O', 'O'], ['O', 'O'], ['O', 'O']])
      end
    end

    context 'when command is invalid' do
      it 'raises a CommandError with command string and comma separated errors' do
        subject = described_class.new('I 250 0')

        expect { subject.execute! }.to raise_error(CommandError, "I 250 0: M should be greater than 0 and less than 250, N should be greater than 0 and less than 250")
      end
    end
  end
end
