data = File.open("./data.txt").readlines
# data = File.open("./data-2.txt").readlines
# data = File.open("./data-3.txt").readlines
# data = File.open("./data-4.txt").readlines

class Wires
  attr_accessor :wires

  START = { x: 1, y: 1}

  def initialize(data)
    @data = data.map { |d| d.gsub("\n", "") }
    @wires = {
      1 => { set: [], position: START.dup },
      2 => { set: [], position: START.dup }
    }
  end

  def move
    @data.each_with_index do |moves, i|
      moves.split(",").each do |rule|
        rules(rule, i+1)
      end
    end
  end

  def rules(rule, index)
    direction, distance = rule[0], rule[1..-1].to_i
    case direction
    when "U" then update_move(index, :y, distance, 1)
    when "D" then update_move(index, :y, distance, -1)
    when "R" then update_move(index, :x, distance, 1)
    when "L" then update_move(index, :x, distance, -1)
    else
      raise "Invalid input"
    end
  end

  def update_move(index, axis, distance, pos)
    1.upto(distance) do |n|
      point = @wires[index][:position].merge({ axis => @wires[index][:position][axis] + (n * pos) }).values
      @wires[index][:set] << point
    end
    @wires[index][:position][axis] += (distance * pos)
  end

  def find_all_intersections
    @wires[1][:set] & @wires[2][:set]
  end

  def find_closest_intersection
    find_all_intersections.map do |intersection|
      distance_formula(intersection[0], START[:x], intersection[1], START[:y])
    end.min
  end

  def distance_formula(x2, x1, y2, y1)
    ((x2 - x1).abs + (y2 - y1).abs)
  end
end

wires = Wires.new(data)
wires.move
p "Part 1: #{wires.find_closest_intersection}"