data = File.open("./data.txt").readlines
# data = File.open("./data-2.txt").readlines

class Instruction
  attr_accessor :rule

  def initialize(instruction)
    @rule = parse(instruction)
  end

  def parse(instruction)
    instruction.match(/(?<direction>[NSEWLRF])(?<distance>\d+)/)
  end
end

class Ship
  attr_accessor :position

  ORIENTATION_RULES = {
    "N" => "E",
    "E" => "S",
    "S" => "W",
    "W" => "N"
  }

  def initialize
    @position = {
      x: 0,
      y: 0,
      orientation: "E"
    }
    rule = { direction: "", distance: "0" }
  end

  def navigate(rule)
    case rule[:direction]
    when "L" then turn_left(rule[:distance])
    when "R" then turn_right(rule[:distance])
    when "F" then move_cardinal(position[:orientation], rule[:distance])
    else
      move_cardinal(rule[:direction], rule[:distance])
    end
  end

  def navigate_to_waypoint(waypoint)
    self.position[:x] += waypoint.position[:x]
    self.position[:y] += waypoint.position[:y]
  end

  def calculate_manhattan_distance
    position[:x].abs + position[:y].abs
  end

  private

  def turn_right(degrees)
    turns = degrees.to_i / 90
    turns.times { self.position[:orientation] = ORIENTATION_RULES[position[:orientation]] }
  end

  def turn_left(degrees)
    turns = degrees.to_i / 90
    turns.times { self.position[:orientation] = ORIENTATION_RULES.invert[position[:orientation]] }
  end

  def move_cardinal(direction, distance)
    case direction
    when "N" then self.position[:y] += distance.to_i
    when "S" then self.position[:y] -= distance.to_i
    when "E" then self.position[:x] += distance.to_i
    when "W" then self.position[:x] -= distance.to_i
    end
  end
end

class Waypoint
  attr_accessor :position

  def initialize
    # (0, 0) is the ship
    @position = {
      x: 10,
      y: 1
    }
  end

  def move(rule)
    case rule[:direction]
    when "L" then turn_left(rule[:distance])
    when "R" then turn_right(rule[:distance])
    else
      move_cardinal(rule[:direction], rule[:distance])
    end
  end

  def move_cardinal(direction, distance)
    case direction
    when "N" then self.position[:y] += distance.to_i
    when "S" then self.position[:y] -= distance.to_i
    when "E" then self.position[:x] += distance.to_i
    when "W" then self.position[:x] -= distance.to_i
    end
  end

  private

  def turn_right(degrees)
    turns = degrees.to_i / 90
    turns.times { self.position[:x], self.position[:y] = self.position[:y], -self.position[:x] }
  end

  def turn_left(degrees)
    turns = degrees.to_i / 90
    turns.times { self.position[:y], self.position[:x] = self.position[:x], -self.position[:y] }
  end
end

# Part 1
ship_1 = Ship.new
data.each do |task|
  instruction = Instruction.new(task).rule
  ship_1.navigate(instruction)
end
puts "Part 1"
puts ship_1.position
puts ship_1.calculate_manhattan_distance
puts

# Part 2
ship_2 = Ship.new
waypoint = Waypoint.new
data.each do |task|
  instruction = Instruction.new(task).rule
  case instruction[:direction]
  when "F" then instruction[:distance].to_i.times { ship_2.navigate_to_waypoint(waypoint) }
  else
    waypoint.move(instruction)
  end
end

puts "Part 1"
puts ship_2.position
puts ship_2.calculate_manhattan_distance