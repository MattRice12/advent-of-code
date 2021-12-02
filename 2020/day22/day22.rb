# data = File.open("./data.txt").readlines
data = File.open("./data-2.txt").readlines

class Combat
  attr_accessor :player1, :player2

  def initialize(data)
    create_players(data)
  end
  
  def create_players(data)
    @player1, @player2 = data
      .join("")
      .split("\n\n")
      .map { |player_set|
        _, *cards = player_set.split("\n")
        Player.new(cards)
      }
  end

  def play_game
    until @player1.hand.empty? || @player2.hand.empty?
      play_round
    end
    evaluate_winner_deck
  end

  def play_round
    p1_hand, p2_hand = [@player1, @player2].map(&:play)
    if p1_hand > p2_hand
      @player1.win(p1_hand, p2_hand)
    elsif p2_hand > p1_hand
      @player2.win(p2_hand, p1_hand)
    end
  end

  def evaluate_winner_deck
    winning_hand = @player1.hand + @player2.hand
    winning_hand.reverse.map.with_index {|card, index| card * (index + 1) }.sum
  end
end

class Player
  attr_accessor :hand
  def initialize(cards)
    @hand = build_hand(cards)
  end

  def build_hand(cards)
    cards.map(&:to_i)
  end

  def play
    @hand.shift
  end

  def win(*cards)
    @hand += cards
  end
end

game = Combat.new(data)

p game.play_game