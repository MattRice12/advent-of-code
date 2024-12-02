class DataParser
  def self.call(path)
    File.readlines(path)
      .map { |line| line.split(" ").map(&:to_i) }
  end
end

class ReportInspector
  def self.call(data, error_forgiveness: false)
    new(data, error_forgiveness).call
  end

  attr_reader :data, :error_forgiveness

  def initialize(data, error_forgiveness)
    @data = data
    @error_forgiveness = error_forgiveness
  end

  def call
    data.count do |level|
      validatable_levels(level).any? {|level| Validator.new(level).valid?}
    end
  end

  def validatable_levels(level)
    return [level] unless error_forgiveness

    # data.map.with_index do |_n, i|
    #   sub_level = level.clone
    #   sub_level.delete_at(i)
    #   sub_level
    # end

    level.map.with_index do |_n, i|
      build_sublevel(level, i)
    end
  end

  def build_sublevel(level, i)
    return level[i+1..-1] if i == 0

    level[0..i-1] + level[i+1..-1]
  end
end

class Validator
  attr_reader :level

  def initialize(level)
    @level = level
  end

  def valid?
    same_direction? &&
      gradual_change?
  end

  def same_direction?
    directions_hash = {"positive" => 0, "negative" => 0, "zero" => 0}

    level
      .each_cons(2)
      .map {|group| NumberInspector.direction(group[0], group[1])}
      .each { |result| directions_hash[result] += 1 }

    directions_hash.values.min(2).sum <= 0
  end

  def gradual_change?
    level
      .each_cons(2)
      .all? {|group| NumberInspector.gradual?(group[0], group[1])}
  end
end

class NumberInspector
  MIN_RANGE = 1
  MAX_RANGE = 3

  def self.direction(num1, num2)
    if num1 > num2
      "positive"
    elsif num1 < num2
      "negative"
    else
      "zero"
    end
  end

  def self.gradual?(num1, num2)
    (num1 - num2).abs.between?(MIN_RANGE, MAX_RANGE)
  end
end

data = DataParser.call("./data.txt")
report_0 = ReportInspector.call(data, error_forgiveness: false)
report_1 = ReportInspector.call(data, error_forgiveness: true)

p report_0
p report_1