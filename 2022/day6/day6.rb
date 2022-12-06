require 'pry'

class Tuning
  attr_reader :data

  PACKET_MARKER = 4
  MESSAGE_MARKER = 14

  def initialize
    @data = File.open('./data.txt').readlines.first.split("")
  end

  def round_1
    sequence = []
    distance = 0
    data.each do |char|
      next if sequence.uniq.length == PACKET_MARKER

      sequence.shift if sequence.length >= PACKET_MARKER
      sequence << char
      distance += 1
    end
    distance
  end

  def round_2
    sequence = []
    distance = 0
    data.each do |char|
      next if sequence.uniq.length == MESSAGE_MARKER

      sequence.shift if sequence.length >= MESSAGE_MARKER
      sequence << char
      distance += 1
    end
    distance
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
