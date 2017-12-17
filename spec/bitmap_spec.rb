require './lib/bitmap'
require './lib/bit'

describe Bitmap do
  describe '#create!' do
    it 'creates a bitmap with M x N bits' do
      expect(described_class.create(3,2).is_a?(Bitmap)).to be_truthy
      expect(described_class.create(3,2).to_a).to eq([['O', 'O', 'O'], ['O', 'O', 'O']])
    end

    it 'creates M x N bits of bit class' do
      expect(described_class.create(3,2).bits.flatten.map(&:class).uniq).to eq([Bit])
    end
  end

  describe '#find_bit' do
    let(:bitmap) { described_class.create(3,2) }

    it 'returns the bit if X and Y are within bounds' do
      expect(bitmap.find_bit(1,1).class).to eq(Bit)
      expect(bitmap.find_bit(3,2).class).to eq(Bit)
      expect(bitmap.find_bit(1,1).to_s).to eq('O')
    end

    it 'raises error if X and Y are outside bounds' do
      expect { bitmap.find_bit(4,2) }.to raise_error('range out of bitmap bounds')
    end
  end
end
