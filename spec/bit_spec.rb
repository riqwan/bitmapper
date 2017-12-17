require './lib/bit'

describe Bit do
  describe '#set_color' do
    let(:bit) { described_class.new(3, 2, 'D') }

    it 'sets the color of the bit' do
      expect { bit.set_color('E') }.to change { bit.c }.from('D').to('E')
      expect { bit.set_color('F') }.to change { bit.c }.from('E').to('F')
    end
  end

  describe '#to_s' do
    let(:bit) { described_class.new(3, 2, 'M') }

    it 'displays the color of the bit' do
      expect(bit.to_s).to eq('M')
    end
  end
end
