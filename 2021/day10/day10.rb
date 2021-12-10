class Day10
  PAIR = {
    ')' => '(',
    ']' => '[',
    '}' => '{',
    '>' => '<'
  }

  SCORE = {
    ')' => 3,
    ']' => 57,
    '}' => 1197,
    '>' => 25137
  }

  SCORE_2 = {
    ')' => 1,
    ']' => 2,
    '}' => 3,
    '>' => 4
  }

  def initialize
    @data = File.open('./data.txt').readlines.map(&:chomp)
    # @data = File.open('./sample_data.txt').readlines.map(&:chomp)
  end

  def part_1
    result = []
    @data.each do |line|
      charlist = []
      skip = false
      line.split('').each do |char|
        next if skip

        case char
        when '(', '[', '{', '<' then charlist << char
        when ')', ']', '}', '>'
          unless charlist.pop == PAIR[char]
            result << char
            skip = true
          end
        end
      end
    end
    result
      .group_by(&:itself)
      .map { |k, v| [k, v.size] }
      .to_h
      .inject(0) { |acc, (k, v)| acc += (SCORE[k] * v) }
  end

  def part_2
    result = @data.map do |line|
      charlist = []
      skip = false
      line.split('').each do |char|
        next if skip

        case char
        when '(', '[', '{', '<' then charlist << PAIR.invert[char]
        when ')', ']', '}', '>'
          unless charlist.pop == char
            charlist = []
            skip = true
          end
        end
      end

      p charlist.reverse.map{|char| SCORE_2[char]}
    end
    scores = result
      .delete_if(&:empty?)
      .map { |line| line.inject(0) { |acc_2, score| (acc_2*5)+score } }
      .sort
    
    scores[scores.length / 2]
  end

end

p Day10.new.part_1
p Day10.new.part_2