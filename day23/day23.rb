data = File.open("./data.txt").readlines
# data = File.open("./data-2.txt").readlines

MOVES = 100
LARGE_MOVES = 10_000_000

def cup_round(cups, sorted_cups)
  cups << cups.shift
  removed_cups = [cups.shift, cups.shift, cups.shift]
  new_sorted_cups = sorted_cups - removed_cups
  destination_cup = new_sorted_cups[new_sorted_cups.index(cups[-1]) - 1]
  destination_cup_index = cups.index(destination_cup)
  cups.insert(destination_cup_index + 1, removed_cups)
  cups.flatten
end

def part1(data)
  cups = data[0].split("").map(&:to_i)

  sorted_cups = cups.sort
  MOVES.times do |move|
    cups = cup_round(cups, sorted_cups)  
  end

  until cups[0] == 1 do
    cups << cups.shift
  end
  "Part 1: #{cups[1..-1].join("")}"
end

p part1(data)

def part2(data)
  cups = data[0].split("").map(&:to_i)
  (cups += (10..1_000_000).to_a).flatten

  sorted_cups = cups.sort
  LARGE_MOVES.times do |move|
    cups = cup_round(cups, sorted_cups)  
  end

  cup_1_index = cups.index(1)
  p cups[cup_1_index + 1]
  p cups[cup_1_index + 2]
  cups_product = cups[cup_1_index + 1] * cups[cup_1_index + 2]
  "Part 2: #{cups_product}"
end

# INCOMPLETE
p part2(data)