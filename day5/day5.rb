data = File.open("./data.txt").readlines

class SeatLocator
  attr_reader :min_row, :max_row, :min_column, :max_column

  def initialize(seat)
    @seat = seat
    @min_row = 0
    @max_row = 127
    @min_column = 0
    @max_column = 7
  end

  def id
    ((row_average * 8) + column_average)
  end

  def find_seat_id
    @seat.each_char do |char|
      case char
      when "B" then binary_back
      when "F" then binary_front
      when "R" then binary_right
      when "L" then binary_left
      end
    end
    id.to_i
  end

  def row_average
    (@min_row + @max_row) / 2.0
  end

  def column_average
    (@min_column + @max_column) / 2.0
  end

  def binary_back
    @min_row = row_average.ceil
  end

  def binary_front
    @max_row = row_average.floor
  end

  def binary_right
    @min_column = column_average.ceil
  end

  def binary_left
    @max_column = column_average.floor
  end

  def highest_seat_id
    highest_id = id if id > highest_id
  end
end

class Plane
  attr_reader :ids

  def initialize(seat_ids)
    @ids = seat_ids.sort
    @highest_seat_id = 0
    @empty_seats = []
  end

  def highest_seat_id
    @highest_seat_id = @ids[-1]
  end

  def find_seats_with_open_neighbor
    @ids.select.with_index { |id, index| seat_has_open_neighbor?(id, index) }
  end

  def seat_has_open_neighbor?(id, index)
    return false if is_first_or_last_seat?(id)
    seat_before_empty = @ids[index - 1] != id - 1
    seat_after_empty = @ids[index + 1] != id + 1
    seat_before_empty || seat_after_empty
  end

  def is_first_or_last_seat?(id)
    # First and last seats necessarily have at least 1 missing neighbor
    # Also rules say to skip first and last
    @ids[0] == id || @ids[-1] == id
  end

  def find_my_seat
    find_seats_with_open_neighbor.inject(0, :+) / 2
  end
end

seat_ids = []

data.each do |seat|
  locater = SeatLocator.new(seat)
  seat_ids << locater.find_seat_id
end

puts "Highest seat = #{Plane.new(seat_ids).highest_seat_id}"
puts "My seat = #{Plane.new(seat_ids).find_my_seat}"