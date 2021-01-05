data = File.open("./data.txt").readlines
# data = File.open("spec/fixtures/sample_data.txt").readlines

class Orbit
  attr_accessor :orbits

  def initialize(data)
    @data = data
    build_orbit_hash
  end

  def find_orbit(orbit)
    body, moon = orbit.split(")")
    Hash[moon.gsub("\n", ""), body]
  end

  def build_orbit_hash
    @orbits ||= {}
    @data.each do |orbit|
      @orbits.merge!(find_orbit(orbit))
    end
  end

  def count_all_orbits
    @orbits
      .flat_map {|k, v| track_path(k)}
      .length
  end

  def track_path(moon, path = [])
    return path if !@orbits[moon]
    track_path(@orbits[moon], path + [@orbits[moon]])
  end

  def intersection(moon_a, moon_b)
    (track_path(moon_a) & track_path(moon_b))
  end

  def transfers_between_two_moons(moon_a, moon_b)
    below_intersection = intersection(moon_a, moon_b)[1..-1]
    (track_path(moon_a) + track_path(moon_b)).uniq - below_intersection
  end

  def count_transfers_between(moon_a, moon_b)
    transfers_between_two_moons(moon_a, moon_b).count - 1
  end
end

orbit = Orbit.new(data)
p "Part 1: #{orbit.count_all_orbits}"


p "Part 2: #{orbit.count_transfers_between("YOU", "SAN")}"