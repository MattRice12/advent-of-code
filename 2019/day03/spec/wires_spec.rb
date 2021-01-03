require_relative '../day03.rb'

RSpec.describe Wires do
  DATA = File.open("./data-2.txt").readlines

  describe "initialization" do
    it "initializes" do
      wires = Wires.new(DATA)

      expect(wires).to be_an_instance_of Wires
    end
  end

  describe "rules" do
    it "moves up" do
      wires = Wires.new(DATA)
      wires.wires[1][:position] = {x: 10, y: 10}

      expect(wires.wires[1][:position]).to eq({x: 10, y: 10})

      wires.rules("U5", 1)
      
      expect(wires.wires[1][:position]).to eq({x: 10, y: 15})
    end

    it "moves down" do
      wires = Wires.new(DATA)
      wires.wires[1][:position] = {x: 10, y: 10}

      expect(wires.wires[1][:position]).to eq({x: 10, y: 10})

      wires.rules("D5", 1)
      
      expect(wires.wires[1][:position]).to eq({x: 10, y: 5})
    end

    it "moves right" do
      wires = Wires.new(DATA)
      wires.wires[1][:position] = {x: 10, y: 10}

      expect(wires.wires[1][:position]).to eq({x: 10, y: 10})

      wires.rules("R5", 1)
      
      expect(wires.wires[1][:position]).to eq({x: 15, y: 10})
    end

    it "moves left" do
      wires = Wires.new(DATA)
      wires.wires[1][:position] = {x: 10, y: 10}

      expect(wires.wires[1][:position]).to eq({x: 10, y: 10})

      wires.rules("L5", 1)
      
      expect(wires.wires[1][:position]).to eq({x: 5, y: 10})
    end
    
    it "raises error on invalid direction" do 
      wires = Wires.new(DATA)
      wires.wires[1][:position] = {x: 10, y: 10}

      expect(wires.wires[1][:position]).to eq({x: 10, y: 10})
      expect { wires.rules("P5", 1) }.to raise_error
    end
  end

  describe "update move" do
    it "starts with 0 sets" do
      wires = Wires.new(DATA)
      wires.wires[1][:position] = {x: 10, y: 10}

      expect(wires.wires[1][:set]).to eq([])
    end

    it "adds 3 new points when moving distance of 3" do
      wires = Wires.new(DATA)
      wires.wires[1][:position] = {x: 10, y: 10}

      wires.rules("L3", 1)
      expect(wires.wires[1][:set]).to eq([[9, 10], [8, 10], [7, 10]])
    end
  end

  describe "analyze intersections" do 
    it "finds all intersections" do
      wires = Wires.new(DATA)

      wires.move

      expect(wires.find_all_intersections).to eq([[7, 6], [4, 4]])
    end

    it "finds closest intersection" do
      wires = Wires.new(DATA)

      wires.move

      expect(wires.find_closest_intersection).to eq(6)
    end
  end
end