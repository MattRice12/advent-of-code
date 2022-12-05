require 'pry'

class AssignmentPair
  attr_reader :data

  def initialize
    @data = File.open('./data.txt').readlines
  end

  def round_1
    data.count do |pair|
      first, last = split_pair(pair)

      (first & last) == first || (first & last) == last
    end
  end

  def round_2
    data.count do |pair|
      first, last = split_pair(pair)
      
      (first & last).length > 0
    end
  end

  def split_pair(pair)
    first, last = pair
      .split(",")
      .map {|range| range.split("-").map(&:to_i)}
      .map {|arr| (arr[0]..arr[1]).to_a}
  end
end


def time_it
  st = Time.now
  yield
  puts Time.now - st
end

time_it do
  puts AssignmentPair.new.round_1
end

puts

time_it do
  puts AssignmentPair.new.round_2
end
