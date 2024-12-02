class DataParser
  def self.call(path)
    File.readlines(path)
      .map { |line| line.split(" ").map(&:to_i) }
      .transpose
      .map(&:sort)
  end
end

class Collection
  def self.differences(left, right)
    new(left, right).differences
  end

  def self.similarity_score(left, right)
    new(left, right).similarity_score
  end
  
  attr_reader :left, :right

  def initialize(left, right)
    @left = left
    @right = right
  end

  def differences
    left
      .zip(right)
      .map {|line| Calculations.diff_abs(line[1], line[0])}
      .sum(0)
  end

  def similarity_score
    left.sum(0) do |num1|
      num1 * right.count {|num2| num1 == num2}
    end
  end
end

class Calculations
  def self.diff_abs(num1, num2)
    (num1 - num2).abs
  end
end


data = DataParser.call("./data.txt")
left = data[0]
right = data[1]
result1 = Collection.differences(left, right)
result2 = Collection.similarity_score(left, right)

p result1
p result2