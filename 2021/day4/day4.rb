class Bingo
  def initialize
    # @data = File.open('./data.txt').readlines.map(&:chomp)
    @data = File.open('./data_2.txt').readlines.map(&:chomp)
    # @data = File.open('./sample_data.txt').readlines.map(&:chomp)
    @drawn_numbers = @data[0].split(',').map(&:to_i)
    @boards = build_boards
  end

  def call
    run_game
    @boards.sort_by {|winner| winner[:place]}.each do |winner|
      unmarked_nums = (winner[:rows] | winner[:cols]).flatten.uniq
      drawn_nums = @drawn_numbers[0..winner[:winning_number_idx]]
      sum_unmarked_nums = (unmarked_nums - drawn_nums).inject(0, :+)
      winner[:result] = sum_unmarked_nums * @drawn_numbers[winner[:winning_number_idx]]
    end
    {
      'Round 1' => @boards.find {|board| board[:place] == 0}[:result],
      'Round 2' => @boards.find {|board| board[:place] == @boards.length - 1}[:result],
    }
  end

  def run_game
    place = 0
    @drawn_numbers.each_with_index do |_num, i|
      @boards.each_with_index do |board, j|
        next if board[:place]
        if board_wins?(board, @drawn_numbers[0..i])
          board[:winning_number_idx] = i
          board[:place] = place
          place += 1
        end
      end
    end
  end

  def build_boards
    boards = []
    idx = 0
    @data[1..-1].each_with_index do |line|
      idx += 1 and next if line == ''
      boards[idx] ||= []
      boards[idx] << line.split(' ').map(&:to_i)
    end
    boards.compact.map.with_index do |board, i|
      result = {}
      result[:idx] = i
      result[:rows] = board
      result[:cols] = board.transpose
      result
    end
  end

  def board_wins?(board, drawn_numbers_set)
    board[:rows].any? { |row| (row - drawn_numbers_set).empty? } ||
      board[:cols].any? { |col| (col - drawn_numbers_set).empty? }
  end
end

p Bingo.new.call