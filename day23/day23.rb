data = File.open("./data.txt").readlines
# data = File.open("./data-2.txt").readlines

class Attempt1
  MOVES = 100

  def self.execute(data)
    cups = data[0].split("").map(&:to_i)

    sorted_cups = cups.sort
    MOVES.times do |move|
      cups = cup_round(cups, sorted_cups)  
    end

    until cups[0] == 1 do
      cups << cups.shift
    end
    p "Part 1: #{cups[1..-1].join("")}"
  end
  
  def self.cup_round(cups, sorted_cups)
    cups << cups.shift
    removed_cups = [cups.shift, cups.shift, cups.shift]
    new_sorted_cups = sorted_cups - removed_cups
    destination_cup = new_sorted_cups[new_sorted_cups.index(cups[-1]) - 1]
    destination_cup_index = cups.index(destination_cup)
    cups.insert(destination_cup_index + 1, removed_cups)
    cups.flatten
  end
end

Attempt1.execute(data)

class Attempt2
  LARGE_MOVES = 10_000_000

  def self.execute(data)
    cups = data[0].split("").map(&:to_i)
    (cups += (10..1_000_000).to_a).flatten

    cups_hash = Hash[cups.zip(cups[1..-1] + [cups[0]])]

    start = cups[0]
    LARGE_MOVES.times do |move|
      start = cup_round_2(cups, cups_hash, move % cups.length, start)  
    end

    first = cups_hash[1]
    second = cups_hash[first]
    p "first = #{first}"
    p "second = #{second}"
    p "Part 2: #{first * second}"
  end


  def self.cup_round_2(cups, cups_hash, move, start)
    cc_key = start
    cc_value = cups_hash[cc_key]

    frc_key = cups_hash[cc_key]
    src_key = cups_hash[frc_key]
    trc_key = cups_hash[src_key]
    frc_value = cups_hash[frc_key]
    src_value = cups_hash[src_key]
    trc_value = cups_hash[trc_key]

    removed_cups = [frc_key, src_key, trc_key]

    dc_key = get_dc_key(cups, removed_cups, cc_key)

    dc_value = cups_hash[dc_key]
    cups_hash[cc_key] = trc_value
    cups_hash[trc_key] = dc_value
    cups_hash[dc_key] = cc_value

    cups_hash[cc_key]
  end

  def self.get_dc_key(cups, removed_cups, cc_key)
    n = 1
    found = false
    dc_key = cc_key - n
    until found do
      raise if n > 4
      dc_key = dc_key <= 0 ? cups.length + 1 - n : dc_key
      if removed_cups.include?(dc_key)
        n += 1
      else
        found = true
      end
    end
    dc_key
  end

  def self.ordered_cups(cups_hash, n)
    final_arr = []
    while final_arr.length < cups_hash.length - 1
      final_arr << cups_hash[n]
      n = cups_hash[n]
    end
    final_arr
  end
end

Attempt2.execute(data)