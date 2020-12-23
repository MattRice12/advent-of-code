require_relative '../day22.rb'

RSpec.describe Player do
  CARDS = ["1", "2", "3", "4", "5"]

  describe "initialization" do
    it "initializes" do
      player = Player.new(CARDS)

      expect(player).to be_an_instance_of Player
    end

    it "builds hand" do
      player = Player.new(CARDS)

      expect(player.build_hand(CARDS)).to eq([1, 2, 3, 4, 5])
    end
  end

  describe "actions" do
    it "a card is removed from the front of the deck when the player plays a card" do
      player = Player.new(CARDS)
      player.play

      expect(player.hand).to eq([2, 3, 4, 5])
    end

    it "cards are added to the back of the deck a player wins a round" do
      player = Player.new(CARDS)
      player.win(9, 10)

      expect(player.hand).to eq([1, 2, 3, 4, 5, 9, 10])
    end
  end
end