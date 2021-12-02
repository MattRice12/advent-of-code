data = File.open("./data.txt").readlines
# data = File.open("./data-2.txt").readlines

class Seat
  attr_accessor :x, :y, :value

  OCCUPIED = "#"
  UNOCCUPIED = "L"
  FLOOR = "."

  def initialize(x, y, value)
    @x = x
    @y = y
    @value = value
  end

  def occupied?
    @value == OCCUPIED
  end

  def unoccupied?
    @value == UNOCCUPIED
  end

  def floor?
    @value == FLOOR
  end

  def to_s
    value
  end
  alias_method :inspect, :to_s
end


class Life
  attr_accessor :seats, :round, :seat_count

  def initialize(data)
    @seats = build(data)
    @round = 0
    @seat_count = 0
  end

  def build(data)
    blank_aisle = Seat::FLOOR * (data[0].length - 1)

    section = [
      blank_aisle,
      data,
      blank_aisle
    ].flatten

    section.map.with_index do |y, i|
      [Seat::FLOOR, y.strip.split(""), Seat::FLOOR].flatten.map.with_index do |x, j|
        { "x#{j}_y#{i}" => Seat.new(j, i, x) }
      end
    end.flatten.inject({}, :merge)
  end

  def find_adjacent(x, y)
    (x-1..x+1).map do |x1|
      (y-1..y+1).map do |y1|
        next if x1 == x && y1 == y
        seats["x#{x1}_y#{y1}"] 
      end
    end.flatten.compact
  end

  def all_adjacent_seats_empty?(seat)
    find_adjacent(seat.x, seat.y).count { |s| !s.occupied? } == 8
  end

  def four_adjacent_seats_occupied?(seat)
    find_adjacent(seat.x, seat.y).count { |s| s.occupied? } >= 4
  end

  def find_next_seat(previous_seat)
    return Seat::FLOOR      if previous_seat.floor?
    return Seat::OCCUPIED   if previous_seat.unoccupied? && all_adjacent_seats_empty?(previous_seat)
    return Seat::UNOCCUPIED if previous_seat.occupied? && four_adjacent_seats_occupied?(previous_seat)
    previous_seat.value
  end

  def tick
    self.round += 1
    next_seats = Hash.new()
    seats.each do |k, previous_seat|
      next_seats[k] = Seat.new(
        previous_seat.x,
        previous_seat.y,
        find_next_seat(previous_seat)
      )
    end
    self.seats = next_seats
  end

  def count_seats
    self.seat_count = seats.values.count {|v| v.value == "#"}
  end

  def to_s
    puts "Round #{self.round}"
    self.seats.values.group_by {|s| s.y}.sort.map {|_, v| [v, "\n"]}.join("")
  end
  alias_method :inspect, :to_s
end

life = Life.new(data)

previous_count = 0

life.tick
life.count_seats
until life.seat_count == previous_count do
  previous_count = life.seat_count
  life.tick
  life.count_seats
  puts life
  puts previous_count
  puts life.seat_count
end

puts life
puts life.seat_count
