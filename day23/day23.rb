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

# p part1(data)

def cup_round_2(cups, cups_hash, move, start)
  cc_key = start
  cc_value = cups_hash[cc_key]

  frc_key = cups_hash[cc_key]
  src_key = cups_hash[frc_key]
  trc_key = cups_hash[src_key]
  frc_value = cups_hash[frc_key]
  src_value = cups_hash[src_key]
  trc_value = cups_hash[trc_key]

  removed_cups = [frc_key, src_key, trc_key]

  n = 1
  found = false
  dc_key = cc_key - n
  until found do
    raise if n > 4
    dc_key = cc_key - n <= 0 ? cups.length + 1 - n : cc_key - n
    if removed_cups.include?(dc_key)
      n += 1
    else
      found = true
    end
  end

  # p "cups: (#{cc_key}) #{ordered_cups(cups_hash, cc_key).join(" ")}"
  # p "pick up: #{removed_cups.join(", ")}"
  # p "destination: #{dc_key}"
  # puts

  dc_value = cups_hash[dc_key]

  # current_cup's key => third_removed_cup's value
  cups_hash[cc_key] = trc_value


  # third_removed_cup's key => destination_cup's value
  cups_hash[trc_key] = dc_value

  
  # destination_cup's key => current_cups's value
  cups_hash[dc_key] = cc_value

  cups_hash[cc_key]
end

def part2(data)
  cups = data[0].split("").map(&:to_i)
  (cups += (10..1_000_000).to_a).flatten

  cups_hash = Hash[cups.zip(cups[1..-1] + [cups[0]])]

  start = cups[0]
  LARGE_MOVES.times do |move|
    # p "move: #{move+1}"

    start = cup_round_2(cups, cups_hash, move % cups.length, start)  
  end

  first = cups_hash[1]
  second = cups_hash[first]
  p "first = #{first}"
  p "second = #{second}"
  # p "final = #{ordered_cups(cups_hash, 1).join("")}"

  "Part 2: #{first * second}"
end

def ordered_cups(cups_hash, n)
  final_arr = []
  while final_arr.length < cups_hash.length - 1
    final_arr << cups_hash[n]
    n = cups_hash[n]
  end
  final_arr
end

p part2(data)