require 'pry'

class Tuning
  attr_reader :data

  PACKET_MARKER = 4
  MESSAGE_MARKER = 14

  def initialize
    @data = File.open('./data.txt').readlines.first.split("")
  end

  def round_1
    marker_tuning(PACKET_MARKER)
  end

  def round_2
    marker_tuning(MESSAGE_MARKER)
  end

  def marker_tuning(marker)
    data.each_cons(marker).with_index {|a, i| return i+marker if a.uniq.length == marker}
  end
end


def time_it
  st = Time.now
  yield
  puts Time.now - st
end

time_it do
  puts Tuning.new.round_1
end

puts

time_it do
  puts Tuning.new.round_2
end
