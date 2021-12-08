class Day8
  SEGS = {
    0 => 6,
    1 => 2,
    2 => 5,
    3 => 5,
    4 => 4,
    5 => 5,
    6 => 6,
    7 => 3,
    8 => 7,
    9 => 6
  }
  
  def initialize
    @data = File.open('./data.txt').readlines.map(&:chomp)
    # @data = File.open('./sample_data.txt').readlines.map(&:chomp)
  end

  def part_1
    @data.inject(0) do |acc, line|
      signal_v, output_v = line.split('|')
      acc += output_v
        .split(' ')
        .select{ |v| [SEGS[1], SEGS[4], SEGS[7], SEGS[8]].include?(v.length) }
        .count
    end
  end

  def part_2
    total = []
    @data.each do |line|
      output = {}
      signal_v, output_v = line.split('|')
      items = [signal_v, output_v].uniq.join(' ').split(' ')
      items.each do |item|
        item = item.chars.sort.join
        case item.length
        when SEGS[1] then output[1] = item
        when SEGS[4] then output[4] = item
        when SEGS[7] then output[7] = item
        when SEGS[8] then output[8] = item
        end
      end
      
      new_items = items.reject { |item| [SEGS[1], SEGS[4], SEGS[7], SEGS[8]].include?(item.length) }

      new_items.each do |item|
        item = item.chars.sort.join

        if [SEGS[1], SEGS[4], SEGS[7], SEGS[8]].include?(item.length)
          next
        elsif item.length == SEGS[2] && item.delete(output[4]).length == 3
          output[2] = item
        elsif item.delete(output[1]).length == 3
          output[3] = item
        elsif item.length == SEGS[5] && item.delete(output[4]).length == 2
          output[5] = item
        elsif item.length == SEGS[6] && item.delete(output[1]).length == 5
          output[6] = item
        elsif item.length == SEGS[9] && item.delete(output[4]).length == 2
          output[9] = item
        else
          output[0] = item
        end
      end

      inverted_output = output.invert
      result = output_v.split(' ').inject([]) do |acc, item|
        item = item.chars.sort.join
        acc << inverted_output[item]
      end
      total << result.map(&:to_s).join('')
    end
    total.inject(0) {|acc, item| acc += item.to_i}
  end
end

p Day8.new.part_1
p Day8.new.part_2