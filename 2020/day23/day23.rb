data = File.open("./data.txt").readlines
# data = File.open("./data-2.txt").readlines


# iterating, sorting, inserting, deleting are all at least O(n), which won't scale to 10_000_000 moves
class InefficientAlgorithm
  attr_accessor :cups

  MOVES = 100

  def initialize(data)
    @cups = data[0].split("").map(&:to_i) 
  end

  def execute
    sorted_cups = cups.sort
    MOVES.times do |move|
      self.cups = play(cups, sorted_cups)  
    end

    until cups[0] == 1 do
      self.cups << cups.shift
    end
    p "Part 1: #{cups[1..-1].join("")}"
  end
  
  def play(cups, sorted_cups)
    self.cups << cups.shift
    removed_cups = [cups.shift, cups.shift, cups.shift]
    new_sorted_cups = sorted_cups - removed_cups
    destination_cup = new_sorted_cups[new_sorted_cups.index(cups[-1]) - 1]
    destination_cup_index = cups.index(destination_cup)
    cups.insert(destination_cup_index + 1, removed_cups)
    cups.flatten
  end
end

InefficientAlgorithm.new(data).execute


# Using linked list type hashes for O(1) efficiency, which scales to 10_000_000 moves
class EfficientAlgorithm
  attr_accessor :cups, :cups_hash
  
  MOVES = 10_000_000
  CUP_MAX = 1_000_000

  def initialize(data)
    @cups = build_cups(data)
    @cups_hash = Hash[@cups.zip(@cups[1..-1] + [@cups[0]])]
  end

  def build_cups(data)
    original_cups = data[0].split("").map(&:to_i)
    extra_cups = ((original_cups.length + 1)..CUP_MAX).to_a
    original_cups + extra_cups
  end

  def execute
    next_cc_key = cups[0]
    MOVES.times do |move|
      next_cc_key = play(move % cups.length, next_cc_key)  
    end

    first = cups_hash[1]
    second = cups_hash[first]
    p "first = #{first}"
    p "second = #{second}"
    p "Part 2: #{first * second}"
  end

  # cc == current cup
  # frc == first removed cup
  # src == second ""
  # trc == third ""
  # dc == destination cup
  def play(move, cc_key)
    frc_key = cups_hash[cc_key]
    src_key = cups_hash[frc_key]
    trc_key = cups_hash[src_key]

    removed_cups = [frc_key, src_key, trc_key]

    dc_key = get_dc_key(removed_cups, cc_key)

    dc_value = cups_hash[dc_key]
    self.cups_hash[dc_key] = cups_hash[cc_key]
    self.cups_hash[cc_key] = cups_hash[trc_key]
    self.cups_hash[trc_key] = dc_value

    cups_hash[cc_key]
  end

  def get_dc_key(removed_cups, cc_key, n = 1)
    dc_key = cc_key - n < 1 ? cups.length + 1 - n : cc_key - n
    dc_key = get_dc_key(removed_cups, cc_key, n + 1) if removed_cups.include?(dc_key)
    dc_key
  end
end

EfficientAlgorithm.new(data).execute