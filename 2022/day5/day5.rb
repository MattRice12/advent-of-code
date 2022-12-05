require 'pry'

class Parser
  attr_reader :data, :stack, :rules

  def initialize(data)
    @data = data
    @stack = {}
    @rules = ""
  end

  def call
    stack_str, rules = split_stack_and_rules
    [build_stack(stack_str), rules]
  end

  def split_stack_and_rules
    data.join("").split("\n\n").map {|arr| arr.split("\n")}
  end

  def build_stack(stack_str)
    stack_str = stack_str.map {|a| a.gsub(/[a\[\]]/, "").gsub("  ", " ")}[0..-2]

    stack_str.each_with_index do |y, i|
      y.chars.select.with_index {|_, i| i.even?}.each_with_index do |x, j|
        next if x == " "
        stack[j+1] ||= []
        stack[j+1] << x
      end
    end
    stack.sort.to_h
  end
end

class CrateMover900x
  attr_reader :data, :stack, :rules

  def initialize
    @data = File.open('./data.txt').readlines
    @stack = {}
    @rules = []
  end

  def round_1
    @stack, @rules = Parser.new(data).call
  
    perform_9000_rules
  end

  def round_2
    @stack, @rules = Parser.new(data).call
  
    perform_9001_rules
  end

  def perform_9000_rules
    rules.each do |rule|
      move_count, from, to = rule.split(/move | from | to /).reject(&:empty?).map(&:to_i)

      move_count.to_i.times do
        next if stack[from].empty?

        stack[to].unshift(stack[from].shift)
      end

    end
    stack.values.map(&:first).join("")
  end

  def perform_9001_rules
    rules.each do |rule|
      move_count, from, to = rule.split(/move | from | to /).reject(&:empty?).map(&:to_i)

      crates_from = stack[from].first(move_count)
      stack[from] = stack[from].drop(move_count)
      stack[to] = crates_from + stack[to]
    end
    stack.values.map(&:first).join("")
  end
end

def time_it
  st = Time.now
  yield
  puts Time.now - st
end

time_it do
  puts CrateMover900x.new.round_1
end

puts

time_it do
  puts CrateMover900x.new.round_2
end
