rules = File.open("./data.txt").readlines.map(&:to_i)
# rules = File.open("./data-2.txt").readlines.map(&:to_i)

PREAMBLE = 25
continue = true
index_start = 0
index_end = index_start + PREAMBLE

class VM
  attr_accessor :rules, :target_value, :index_start, :index_end, :running, :encryption_weakness
  
  PREAMBLE = 25

  def initialize
    @rules = []
    @continue = true
    @index_start = 0
    @index_end = index_start + PREAMBLE
    @target_value = rules[index_end + 1]
    @encryption_weakness = 0
    @running = true
  end

  def terminated?
    self.running == false
  end

  def value_exceeds_target?(rule)
    rule > target_value
  end

  def find_broken_chain
    self.target_value = rules[index_end + 1]
    self.running = false
    
    rules[index_start..(index_end - 1)].each_with_index do |rule, i|
      rules[(index_start + i + 1)..index_end].each do |rule2|
        if rule + rule2 == target_value
          self.running = true 
          self.index_start += 1
          self.index_end += 1
        end
      end
    end
  end

  def find_contiguous_set
    self.running = true
    rules[0..-2].each_with_index do |rule, i|
      break if terminated? || value_exceeds_target?(rule)
      set = [rule]
      rules[(i + 1)..-1].each do |rule2|
        next if terminated? || value_exceeds_target?(rule2) 
        set << rule2
        sum = set.sum
        break if value_exceeds_target?(sum)
        if sum == target_value
          self.running = false
          self.encryption_weakness = [set.min, set.max].sum
        end
      end
    end
  end
end

def load(machine, rules)
  machine.rules = rules
  until machine.terminated?
    machine.find_broken_chain
  end

  machine.find_contiguous_set

  machine
end

machine = load(VM.new, rules)

puts "Part 1: #{machine.target_value}"
puts "Part 2: #{machine.encryption_weakness}"