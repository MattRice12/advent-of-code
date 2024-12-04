class DataParser
  def self.call(path)
    File.readlines(path).map {|line| line.gsub("\n", "").split("")}
  end
end

class WordSearch
  def self.call(data)
    new(data).call
  end
  
  attr_reader :data

  def initialize(data)
    @data = data
    @total = 0
  end

  def call
    @total += count_horizontal
    @total += count_vertical
    @total += count_diagonal_forward
    @total += count_diagonal_backward
  end

  def count_horizontal
    data
      .map(&:join)
      .map {|line| Counter.count(line)}
      .sum
  end

  def count_vertical
    data
      .transpose
      .map(&:join)
      .map {|line| Counter.count(line)}
      .sum
  end

  # OOOOOOOOOOMMAMXXSSMM
  # OOOOOOOOOMSMSMXMAAXO
  # OOOOOOOOMAXAAASXMMOO
  # OOOOOOOSMSMSMMAMXOOO
  # OOOOOOXXXAAMSMMAOOOO
  # OOOOOXMMSMXAAXXOOOOO
  # OOOOMSAMXXSSMMOOOOOO
  # OOOAMASAAXAMAOOOOOOO
  # OOSSMMMMSAMSOOOOOOOO
  # OMAMXMASAMXOOOOOOOOO
  def count_diagonal_forward
    data
      .map.with_index { |line, i| ("O" * (data.length-i)) + line.join("") + ("O" * i) }
      .map {|arr| arr.split("")}
      .transpose
      .map {|line| Counter.count(line.join(""))}
      .sum
  end

  # MMAMXXSSMMOOOOOOOOOO
  # OMSMSMXMAAXOOOOOOOOO
  # OOMAXAAASXMMOOOOOOOO
  # OOOSMSMSMMAMXOOOOOOO
  # OOOOXXXAAMSMMAOOOOOO
  # OOOOOXMMSMXAAXXOOOOO
  # OOOOOOMSAMXXSSMMOOOO
  # OOOOOOOAMASAAXAMAOOO
  # OOOOOOOOSSMMMMSAMSOO
  # OOOOOOOOOMAMXMASAMXO
  def count_diagonal_backward
    data
      .map.with_index { |line, i| ("O" * i) + line.join("") + ("O" * (data.length-i)) }
      .map {|arr| arr.split("")}
      .transpose
      .map {|line| Counter.count(line.join(""))}
      .sum
  end
end

class Counter
  CODE = "XMAS"

  def self.count(line)
    new(line).count
  end

  attr_reader :line

  def initialize(line)
    @line = line
  end

  def count
    count_forward + count_reverse
  end

  def count_forward
    line.scan(CODE).count
  end

  def count_reverse
    line.scan(CODE.reverse).count
  end
end


# FILE_LOCATION = "./sample_data.txt"
FILE_LOCATION = "./data.txt"

data = DataParser.call(FILE_LOCATION)
report_0 = WordSearch.call(data)

p report_0
# p report_1