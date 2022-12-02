class CountCalories
  attr_reader :data, :elves
  def initialize
    @data = File.open('./data.txt').readlines
    @elves = []
  end

  def find_highest_calories
    group_calorie_sum_by_elf

    highest_calories
  end

  def find_highest_calories_for_3
    group_calorie_sum_by_elf

    highest_calories_for_3
  end

  def group_calorie_sum_by_elf
    elf_number = 0
    
    data.each do |line|
      elf_number += 1 and next if line == "\n"

      elves[elf_number] ||= 0
      elves[elf_number] += line.to_i
    end
  end

  def highest_calories
    elves.max
  end

  def highest_calories_for_3
    elves.sort.reverse.take(3).sum
  end
end


puts CountCalories.new.find_highest_calories
puts CountCalories.new.find_highest_calories_for_3
