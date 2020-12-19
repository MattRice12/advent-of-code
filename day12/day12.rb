data = File.open("./data.txt").readlines
# data = File.open("./data-2.txt").readlines

class Navigate

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
  end

  def move(instruction)
    rule = instruction.match(/(?<direction>[NSEWLRF])(?<distance>\d+)/)
    puts "rule=#{rule}"
    case rule[:direction]
    when "L" then turn_left(rule[:distance])
    when "R" then turn_right(rule[:distance])
    when "F" then move_cardinal(position[:orientation], rule[:distance])
    else
      move_cardinal(rule[:direction], rule[:distance])
    end
    puts "position=#{position}"
  end

  def calculate_manhattan_distance
    position[:x].abs + position[:y].abs
  end

  private

  def turn_right(degrees)
    turns = degrees.to_i / 90
    turns.times do
      self.position[:orientation] = ORIENTATION_RULES[position[:orientation]]
    end
  end

  def turn_left(degrees)
    turns = degrees.to_i / 90
    turns.times do
      self.position[:orientation] = ORIENTATION_RULES.invert[position[:orientation]]
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
end

navigate = Navigate.new

data.each do |instruction|
  # puts "instruction=#{instruction}"
  navigate.move(instruction)
end

puts navigate.position

puts navigate.calculate_manhattan_distance