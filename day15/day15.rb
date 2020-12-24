data = File.open("./data.txt").readlines
# data = File.open("./data-2.txt").readlines

class SpokenGame
  attr_accessor :data, :num_hash, :last_num

  # TURNS = 2020
  TURNS = 30_000_000

  def initialize(data)
    build_data(data)
  end

  def build_data(data)
    @data = data.join("").split(",")
    @num_hash = @data[0..-2].each_with_object({}).with_index { |(num, acc), i| acc[num.to_i] = (i+1) }
    @last_num = @data[-1].to_i
  end

  def play(turn)
    previous_turn = turn - 1
    next_num = 0
    next_num = previous_turn - @num_hash[@last_num] if @num_hash[@last_num]
    @num_hash[@last_num] = previous_turn
    next_num
  end

  def execute
    n = @data.length
    while n < TURNS do
      self.last_num = play(n+=1)
    end
    self.last_num
  end
end

spoken_game = SpokenGame.new(data).execute

p spoken_game