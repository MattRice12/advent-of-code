rules = File.open("./data.txt").readlines.map(&:to_i)
# rules = File.open("./data-2.txt").readlines.map(&:to_i)

PREAMBLE = 25
continue = true
index_start = 0
index_end = index_start + PREAMBLE

class VM
  attr_accessor :rules, :target_value, :index_start, :index_end
  
  PREAMBLE = 25

  def initialize
    @rules = []
    @continue = true
    @index_start = 0
    @index_end = index_start + PREAMBLE
    @target_value = rules[index_end + 1]
    @running = true
  end

  def terminated?
    @running == false
  end

  def find_broken_chain
    self.target_value = rules[index_end + 1]
    @running = false
    
    rules[index_start..(index_end - 1)].each_with_index do |rule, i|
      rules[(index_start + i + 1)..index_end].each do |rule2|
        if rule + rule2 == target_value
          @running = true 
          self.index_start += 1
          self.index_end += 1
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
  machine
end


machine = load(VM.new, rules)

puts "Part 1: #{machine.target_value}"