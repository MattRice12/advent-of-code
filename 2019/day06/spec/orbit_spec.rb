require_relative "../day06.rb"

RSpec.describe Orbit do
  DATA = File.open("spec/fixtures/sample_data.txt").readlines
  DATA_2 = File.open("spec/fixtures/sample_data_2.txt").readlines

  describe "initialization" do
    it "initializes" do
      orbit = Orbit.new([])

      expect(orbit).to be_an_instance_of(Orbit)
    end
  end

  describe "build orbit chain" do
    it "splits string into orbiter and orbitee" do
      orbit = Orbit.new([])

      expect(orbit.find_orbit("B)C")).to eq({"C" => "B"})
    end
    
    it "build hash of all orbits for each planet" do
      orbit = Orbit.new(["COM)B", "B)C", "C)D"])

      expect(orbit.orbits).to eq({"B" => "COM", "C" => "B", "D" => "C"})
    end
  end

  describe "count orbits" do
    it "list total orbits for single moon" do
      orbit = Orbit.new(["COM)B", "B)C", "C)D"])

      expect(orbit.track_path("D")).to eq(["C", "B", "COM"])
    end

    it "count total orbits for all moons" do
      orbit = Orbit.new(["COM)B", "B)C", "C)D"])

      expect(orbit.count_all_orbits).to eq(6)
    end

    it "count total orbits in larger data set" do
      orbit = Orbit.new(DATA)

      expect(orbit.count_all_orbits).to eq(42)
    end
  end

  describe "navigating orbits" do
    it "track path of one orbit" do
      orbit = Orbit.new(["A)B", "B)C", "C)D", "B)E", "E)F"])  

      expect(orbit.track_path("D")).to eq(["C", "B", "A"])
    end
    
    it "find intersection and below" do
      orbit = Orbit.new(["A)B", "B)C", "C)D", "B)E", "E)F"])

      expect(orbit.intersection("D", "F")).to eq(["B", "A"])
    end

    it "find transfers between two moons" do
      orbit = Orbit.new(["A)B", "B)C", "C)D", "B)E", "E)F"])

      expect(orbit.transfers_between_two_moons("D", "F")).to eq(["C", "B", "E"])
    end

    it "count transfers between two moons" do
      orbit = Orbit.new(["A)B", "B)C", "C)D", "B)E", "E)F"])

      expect(orbit.count_transfers_between("D", "F")).to eq(2)
    end
  end
end