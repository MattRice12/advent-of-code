require 'pry'

class Rucksack
  attr_reader :data

  def initialize
    @data = File.open('./data.txt')
  end

  def round_1
    data.readlines.map do |sack|
      sack.delete("\n")
      left, right = split_by_pocket(sack)
      overlap = (left.chars & right.chars).first
      char_value[overlap]
    end.sum
  end

  def round_2
    groups = data.read.split("\n").each_slice(3).to_a
    groups.map do |group|
      overlap = (group[0].chars & group[1].chars & group[2].chars).first
      char_value[overlap]
    end.sum
  end

  def split_by_pocket(sack)
    sack.chars.each_slice(sack.length / 2).map(&:join)
  end

  def char_value
    lower_case = ("a".."z").map.with_index {|letter, i| {letter => i + 1}}.inject(&:merge)
    upper_case = ("A".."Z").map.with_index {|letter, i| {letter => i + 27}}.inject(&:merge)
    lower_case.merge(upper_case)
  end
end

def time_it
  st = Time.now
  yield
  puts Time.now - st
end

time_it do
  puts Rucksack.new.round_1
end

puts

time_it do
  puts Rucksack.new.round_2
end
