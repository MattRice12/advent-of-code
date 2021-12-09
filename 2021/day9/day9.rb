class Day9
  def initialize
    @data = File.open('./data.txt').readlines.map(&:chomp)
    # @data = File.open('./sample_data.txt').readlines.map(&:chomp)
    @height_map = {}
    @dup_map = {}
    build_height_maps
  end

  def build_height_maps
    @data.each_with_index do |row, y|
      row.split('').each_with_index do |col, x|
        @height_map["#{x}_#{y}"] = col.to_i
        @dup_map["#{x}_#{y}"] = false
      end
    end
  end

  def part_1
    result = []
    @data.each_with_index do |row, y|
      row.split('').each_with_index do |col, x|
        col = col.to_i
        result << col+1 if low_point?(x, y, col)
      end
    end

    result.inject(0, :+)
  end

  def part_2
    result = []
    @data.each_with_index do |row, y|
      row.split('').each_with_index do |col, x|
        col = col.to_i
        if low_point?(x, y, col)
          result << {"#{x}_#{y}" => find_basin(x, y, "#{x}_#{y}").flatten.uniq.count}
        end
      end
    end
    p result.inject({}, :merge).values.max(3).inject(1, :*)

    0
    # result.flatten.uniq.inject(1) do |acc, item|
    #   acc *= (@height_map[item] + 1)
    # end
  end

  def find_basin(x, y, point)
    a = [point]
    a << neighbor(x-1, y)
    a << neighbor(x+1, y)
    a << neighbor(x, y-1)
    a << neighbor(x, y+1)
    a
  end

  def neighbor(x, y)
    b = []
    unless edge?(x, y) || @dup_map["#{x}_#{y}"]
      b << "#{x}_#{y}"
      @dup_map["#{x}_#{y}"] = true
      b << find_basin(x, y, "#{x}_#{y}")
    end
    b
  end

  def edge?(x, y)
    @height_map["#{x}_#{y}"].nil? || @height_map["#{x}_#{y}"] == 9
  end

  def low_point?(x, y, col)
    check?(x-1, y, col) && check?(x+1, y, col) && check?(x, y-1, col) && check?(x, y+1, col)
  end

  def check?(x, y, col)
    @height_map["#{x}_#{y}"].nil? || @height_map["#{x}_#{y}"] > col
  end
end

p Day9.new.part_1
p Day9.new.part_2