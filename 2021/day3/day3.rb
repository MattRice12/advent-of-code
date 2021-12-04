class Submarine
  attr_accessor :data, :positions, :gamma, :epsilon
  
  def initialize
    @data = File.open('./data.txt').readlines.map(&:chomp)
    # @data = [
    #   '00100',
    #   '11110',
    #   '10110',
    #   '10111',
    #   '10101',
    #   '01111',
    #   '00111',
    #   '11100',
    #   '10000',
    #   '11001',
    #   '00010',
    #   '01010',
    # ]
    transpose_data
    build_gamma_and_epsilon
    build_oxygen_positions
  end

  def transpose_data
    position_length = @data[0].length # 12 positions
    @positions = Array.new(position_length, '')

    @data.each do |line| # 0..999
      0.upto(position_length - 1) do |j| # 0..12
        @positions[j] += line[j]
      end
    end
  end

  def build_gamma_and_epsilon
    @gamma = ''
    @epsilon = ''
    @positions.each do |position|
      if position.count('0') > position.count('1')
        @gamma += '0'
        @epsilon += '1'
      else
        @gamma += '1'
        @epsilon += '0'
      end
    end
  end

  def count_position_decimal
    gamma_rate = @gamma.to_i(2)
    epsilon_rate = @epsilon.to_i(2)

    gamma_rate * epsilon_rate
  end

  def build_oxygen_positions
    @o2_gen = o2_generator(@data, 0).first
    @co2_gen = co2_generator(@data, 0).first
  end

  def o2_generator(data_a, idx)
    new_data = []
    col = data_a.map {|line| line.split('')}.transpose[idx]
    ones = col.count('1')
    zeroes = col.count('0')
    if ones >= zeroes
      new_data = data_a.select {|line| line[idx] == '1'}
    else
      new_data = data_a.select {|line| line[idx] == '0'}
    end
    return new_data if new_data.length == 1
    o2_generator(new_data, idx + 1)
  end

  def co2_generator(data_a, idx)
    new_data = []
    col = data_a.map {|line| line.split('')}.transpose[idx]
    ones = col.count('1')
    zeroes = col.count('0')
    if zeroes <= ones
      new_data = data_a.select {|line| line[idx] == '0'}
    else
      new_data = data_a.select {|line| line[idx] == '1'}
    end
    return new_data if new_data.length == 1
    co2_generator(new_data, idx + 1)
  end

  def count_oxygen_decimal
    p 'o2 -- ' + @o2_gen
    p 'co2 -- ' + @co2_gen
    o2_rate = @o2_gen.to_i(2)
    co2_rate = @co2_gen.to_i(2)

    o2_rate * co2_rate
  end
end

p Submarine.new.count_position_decimal
p Submarine.new.count_oxygen_decimal