data = File.open("./data.txt").readlines

class FuelCounter

  def initialize(data)
    @data = data
  end

  def sum_fuel
    @data
      .map { |mass| calculate(mass.to_i) }
      .sum
  end

  def sum_recursive_fuel
    @data
      .map { |mass| calc_recursively(mass.to_i) }
      .sum
  end

  def calculate(mass)
    (mass / 3).floor - 2
  end

  def calc_recursively(mass, total = 0)
    result = calculate(mass)
    return total if result <= 0
    calc_recursively(result, total + result)
  end
end

# p FuelCounter.new(data).calc_recursively(12)
# p FuelCounter.new(data).calc_recursively(14)
# p FuelCounter.new(data).calc_recursively(1969)
# p FuelCounter.new(data).calc_recursively(100756)

p "Part 1: #{FuelCounter.new(data).sum_fuel}"
p "Part 2: #{FuelCounter.new(data).sum_recursive_fuel}"