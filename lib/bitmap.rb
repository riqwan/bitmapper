class Bitmap
  DEFAULT_COLOR = 'O'

  attr_reader :m, :n, :bits

  def self.create(m, n)
    instance = new(m, n)
    instance.create

    instance
  end

  def initialize(m, n)
    @m = m
    @n = n
  end

  def create
    @bits = create_bits
  end

  def find_bit(x, y)
    raise 'range out of bitmap bounds' if  x > m || x <= 0 || y > n || y <= 0

    bits[y - 1][x - 1]
  end

  def reset
    create
  end

  def to_a
    bits.map do |row|
      row.map do |bit|
        bit.c
      end
    end
  end

  def to_s
    string = ''

    bits.each do |row|
      row.each { |bit| string += bit.to_s }
      string += "\n"
    end

    string
  end

  private

  def create_bits
    (1..n).map do |m_index|
      (1..m).map do |n_index|
        Bit.new(n_index, m_index, DEFAULT_COLOR)
      end
    end
  end
end
