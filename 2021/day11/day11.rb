class Day11
  STEPS = 100

  LOOP = {
    0 => 1,
    1 => 2,
    2 => 3,
    3 => 4,
    4 => 5,
    5 => 6,
    6 => 7,
    7 => 8,
    8 => 9,
    9 => 10,
    10 => 0
  }

  def initialize
    # @data = File.open('./data.txt').readlines.map(&:chomp)
    @data = File.open('./sample_data.txt').readlines.map(&:chomp).map {|a| a.split('').map(&:to_i)}
    @next_data = @data
    @light_count = 0
  end

  def part_1
    1.upto(STEPS) do
      increment_step
      build_octo_map
      count_octopi
    end
    @light_count
  end

  def increment_step
    @next_data = @next_data.map{|row| row.map{|col| LOOP[col]}}
  end

  def build_octo_map
    @octo_map = {}

    @next_data.each_with_index do |row, y|
      row.each_with_index do |col, x|
        @octo_map["#{x}_#{y}"] = col
      end
    end
  end

  def count_octopi
    light_count = 0
    @next_data.each_with_index do |row, y|
      row.each_with_index do |col, x|
        check_adjacent?(x, y)
      end
    end
    light_count
  end

  def check_adjacent?(x, y)
    positions(x, y).each do |position|
      next unless @octo_map[position]
      if @octo_map[position] >= 10
        @next_data[y][x] = LOOP[10]
        x_1, y_1 = position.split('_')
        check_adjacent?(x, y)
        @light_count == 1
      end
    end.flatten.compact
  end

  def positions(x, y)
    ["#{x-1}_#{y+1}", "#{x}_#{y+1}", "#{x+1}_#{y+1}", 
     "#{x-1}_#{y}",                  "#{x+1}_#{y}",
     "#{x-1}_#{y-1}", "#{x}_#{y-1}", "#{x+1}_#{y-1}"]
  end

  def part_2
  end

end

p Day11.new.part_1
p Day11.new.part_2