require_relative '../day22.rb'

RSpec.describe Combat do
  DATA = File.open("./data-2.txt").readlines

  describe "initialization" do
    it "initializes" do
      combat = Combat.new(DATA)

      expect(combat).to be_an_instance_of Combat
    end

    it "creates players" do
      combat = Combat.new(DATA)

      expect(combat.player1).to be_an_instance_of Player
      expect(combat.player2).to be_an_instance_of Player
    end
  end

  describe "play round" do
    it "players hand before playing a round" do
      combat = Combat.new(DATA)

      expect(combat.player1.hand).to eq([9, 2, 6, 3, 1])
    end

    it "players hand after playing a round" do
      combat = Combat.new(DATA)
      combat.play_round

      expect(combat.player1.hand).to eq([2, 6, 3, 1, 9, 5])
    end
  end

  describe "play game" do
    it "player 1's hand after playing the game" do
      combat = Combat.new(DATA)
      combat.play_game

      expect(combat.player1.hand).to eq([])
    end

    it "player 2's hand after playing the game" do
      combat = Combat.new(DATA)
      combat.play_game

      expect(combat.player2.hand).to eq([3, 2, 10, 6, 8, 5, 9, 4, 7, 1])
    end

    it "evaluate player 2's hand after playing the game" do
      combat = Combat.new(DATA)
      combat.play_game

      expect(combat.evaluate_winner_deck).to eq(306)
    end
  end
end