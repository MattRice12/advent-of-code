data = File.open("./data.txt").readlines
# data = File.open("./data-2.txt").readlines
# data = File.open("./data-3.txt").readlines

####Rules
# start with 0 volts
# each adapter can connect connect to a port up to 3 volts below it's rating

####Process Part 1
# Sort each adapter
# Iterate over the sorted list
# Count the jolt difference between the current and previous adapters


####Process Part 2
# check each adapter for a 3 volt range:
  # if volt_diff == 1 or 2 then add to 1 array and create duplicate array
  # if volt_diff == 3 then add to 1 array and continue


# [1, 4, 5, 7, 10]
# [1, 4, 7, 10]


# [3, 1, 2, 3]

# # 1 => dup
# # 2 => dup
# # 3 => no dup

# # 3 => only 1 variation (itself)
# # 2 || 1 => 2 variations

# [0,  1,  4,  5,  6,  7,  10,  11,  12,  15,  16,  19,  21, 22]

# [0,  1,  4]  # interval of 3 -- NO DUP
# [1,  4,  5]  # interval of 3 -- NO DUP
# [4,  5,  6]  # interval of 1 -- DUP * 2
# [5,  6,  7]  # interval of 1 -- DUP * 2
# [6,  7, 10]  # interval of 3 -- NO DUP
# [7, 10, 11]  # interval of 3 -- NO DUP
# [10, 11, 12] # interval of 1 -- DUP * 2
# [11, 12, 15] #interval of 3 -- NO DUP
# [12, 15, 16] #interval of 3 -- NO DUP
# [15, 16, 19] #interval of 3 -- NO DUP
# [16, 19, 21] #interval of 2 -- DUP * 2
# [19, 21, 22] #interval of 2 -- DUP * 2

# 0, 1, 2, 3, 4, 7, 8, 9, 10, 11, 14, 17, 18, 19, 20, 23, 24, 25, 28, 31, 32, 33, 34, 35, 38, 39, 42, 45, 46, 47, 48, 49, 52,



# 1 2 3 4 7 8 9 10

# 1   3 4 7 8 9 10
# 1     4 7 8 9 10
# 1 2   4 7 8 9 10

# 1 2 3 4 7   9 10
# 1 2 3 4 7 8   10
# 1 2 3 4 7     10

# 1   3 4 7 8 9 10
# 1   3 4 7   9 10
# 1   3 4 7 8   10
# 1   3 4 7     10

# 1     4 7 8 9 10
# 1     4 7   9 10
# 1     4 7 8   10
# 1     4 7     10

# 1 2   4 7 8 9 10
# 1 2   4 7   9 10
# 1 2   4 7 8   10
# 1 2   4 7     10

# 1 2 3   7 8 9 10
# 1 2 3   7   9 10
# 1 2 3   7 8   10
# 1 2 3   7     10

# 1   3   7 8 9 10
# 1   3   7   9 10
# 1   3   7 8   10
# 1   3   7     10








# 0, 1, 2, 3
# 012 023 013 03

# 1234              # 3 ==> 4 uniq
# 1234 124 134 14

# 2345              # 3 ==> 4 uniq
# 2345 235 245 25

# 2346              # 4 ==> 2 uniq
# 2346 246 346 236


# 2347              # 5 ==> 1 uniq
# 2347 247 347 47

# 3478              # 5 ==> 1
# 347 478 47

# 4 7 8 9
# 4 7 8  |  4 7 9

# 7 8 9 10
# 7 8 9  |  7 8 10  |  7 9 10  | 

# 9 10 14 17
# 9 10 14  |  9 14

# 10 14 17 18
# 10 14 17  | 10 14 18

# 4, 5, 6, 7
# 456 457
# 467 
# 47


# 4, 7
# 47


# 4, 5, 7
# 457
# 47

# 4, 6, 7
# 467
# 47

# 4, 6, 8

# 46

# 4, 6, 9
# 46





# a = 4
# i = 0

# arr[i+1] - arr[i] == 1



class AdapterChain

  attr_accessor :adapters, :current_voltage, :jolt_counts, :total_combinations

  def initialize(adapters)
    adapters_with_start_and_end = adapters.map(&:to_i).sort
    @adapters = [0, adapters_with_start_and_end, adapters_with_start_and_end.max + 3].flatten
    @current_voltage = 0
    @jolt_counts = {}
    @total_combinations = 1
    @con = []
  end

  def current_jolt_count(volt_diff)
    self.jolt_counts[volt_diff] || 0
  end

  def find_voltage_intervals
    self.adapters.each do |adapter|
      volt_diff = adapter - self.current_voltage
      self.jolt_counts[volt_diff] = current_jolt_count(volt_diff) + 1
      self.current_voltage += volt_diff
    end
    self.jolt_counts[3] += 1
  end

  # def find_all_combinations
  #   puts self.adapters
  #   self.adapters.each_with_index do |adapter, i|
  #     # puts "adapter=#{adapter}"
  #     # lower_interval_dup = [1, 2].include?(adapter - adapters[i])
  #     # higher_interval_dup = [1, 2].include?(adapters[i + 2] - adapter)
  #     return unless adapters[i + 3]

  #     diff_is_2 = (adapters[i + 2] - adapters[i]) == 2
  #     diff_is_3 = (adapters[i + 2] - adapters[i]) == 3
  #     # greater_diff_is_3 = (adapters[i + 3] - adapters[i]) == 3
      


  #     puts
  #     puts "previous_adapter=#{adapters[i]}"
  #     puts "current_adapter=#{adapter}"
  #     puts "next_adapter=#{adapters[i + 2]}"

  #     puts "*2  == #{diff_is_2}"
  #     puts "*2  == #{diff_is_3}"
  #     # puts "*3  == #{greater_diff_is_3}"

  #     self.total_combinations *= 2 if diff_is_2
  #     self.total_combinations *= 2 if diff_is_3
  #     # self.total_combinations *= 3 if greater_diff_is_3
  #   end
  # end

  # def find_all_combinations(iteration, all_combos)
  #   adapter_set = adapters[iteration..iteration + 2]
  #   adapter_set.each_with_index do |adapter, i|
  #     return if iteration > adapter_set.length

      
  #     all_combos << adapter_set if [1].include?(adapter_set[1] - adapter)
  #     all_combos << adapter_set if [2].include?(adapter_set[2] - adapter)
      
      
  #     all_combos << adapter_set
  #     find_all_combinations(iteration + 1, all_combos)
  #   end
  #   all_combos.uniq
  # end


  # def next_adapter(adapters, jolt)
  #   adapters.select { |a| [1, 2, 3].include?(a - jolt) }
  # end

  # def chain_adapters(adapters, jolt, cons)
  #   next_adapter(adapters, jolt)
  #     .tap { |s| return 1 if s.empty? }
  #     .flat_map { |n| chain_adapters(adapters, n, cons + [n]) }
  # end


  # def chain_adapters(adpt, start, finish)
  #   new_adapters = adpt[start..finish]
  #   new_adapters.map do |adapter|
  #     diff_1_1 = (new_adapters[-1] - new_adapters[-2]) == 1
  #     diff_1_2 = (new_adapters[-1] - new_adapters[-2]) == 2
  #     diff_1_3 = (new_adapters[-1] - new_adapters[-2]) == 3

  #     diff_2_2 = (new_adapters[-1] - new_adapters[-3]) == 2
  #     diff_2_3 = (new_adapters[-1] - new_adapters[-3]) == 3

  #     diff_3_3 = (new_adapters[-1] - new_adapters[-4]) == 3

  #     p [new_adapters[-1], new_adapters[-2]]

  #     if diff_3_3
  #       @con << [new_adapters[-1], new_adapters[-4]]
  #     elsif diff_1_1 && diff_2_2
  #       @con << [new_adapters[-1], new_adapters[-2]]
  #     elsif diff_1_1 && diff_2_3
  #       @con << [new_adapters[-1], new_adapters[-3]]
  #     elsif diff_1_2 && diff_2_3
  #       @con << [new_adapters[-1], new_adapters[-4]]



  #     @con << [new_adapters[-1], new_adapters[-2]] if diff_1_1 && diff_2_2
  #     @con << [new_adapters[-1], new_adapters[-3]] if diff_1_1 && diff_2_3
  #     @con << [new_adapters[-1], new_adapters[-4]] if diff_1_2 && diff_2_3

  #     @con << [new_adapters[-1], new_adapters[-2]] if diff_1_1
  #   end
  #   @con
  # end
  
end

chain = AdapterChain.new(data)
chain.find_voltage_intervals


# puts chain.jolt_counts
puts chain.jolt_counts[1] * chain.jolt_counts[3]


# p chain.chain_adapters(data, 0)

# adapters = [0, data.map(&:to_i).sort, data.map(&:to_i).sort.max + 3].flatten

# paths = chain.chain_adapters(adapters.map(&:to_i).sort, 0, -1)

# p paths

# puts chain.total_combinations