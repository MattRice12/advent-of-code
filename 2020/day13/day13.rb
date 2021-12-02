# data = File.open("./data.txt").readlines
# data = File.open("./data-2.txt").readlines
data = File.open("./data-3.txt").readlines
# data = File.open("./data-4.txt").readlines
# data = File.open("./data-7.txt").readlines

# Part 1
bus_times = []
earliest_depart_time = data[0]
data[1].split(",").each do |bus|
  next if bus == "x"
  interval = bus.to_i
  time_until_next_bus = interval - earliest_depart_time.to_i % interval
  bus_times.push({ id: interval, proximity: time_until_next_bus })
end

bus_times = bus_times.sort_by { |time| [time[:proximity]] }
best_bus = bus_times[0]
puts "Part 1: #{best_bus[:proximity] * best_bus[:id]}"


class Schedule
  attr_accessor :current

  def initialize(data)
    @bus_hash = load(data)
    @smallest = @bus_hash.keys[0]
    @largest = @bus_hash.keys[-1]
    @current = @smallest
  end

  def load(data)
    data[1].split(",")
            .map.with_index { |bus, i| { bus.to_i => i } }
            .reject { |bus| bus.keys[0] == 0 }
            .sort_by { |bus| bus.values }
            .reduce({}, :merge)
  end
  
  def all_in_order?
    @bus_hash.all? do |id, interval|
      (self.current + interval) % id == 0
    end
  end

  def iterate
    loop do
      break if all_in_order?
      self.current += @smallest * (@largest / @smallest)
    end
  end
end

# MORE EFFICIENT SOLUTION, BUT NOT MINE
class BusSchedule
  attr_accessor :buses

  def initialize(data)
    @buses = []
    load(data)
  end

  def load(data)
    offset = 0
    data[1].split(',').each do |entry|
      @buses.append([entry.to_i, offset]) unless entry == 'x'
      offset += 1
    end
  end

  def calculate
    time = 0
    interval = 1
    @buses.each do |bus, offset|
      time += interval until (time + offset) % bus == 0
      interval *= bus
    end
    time
  end
end


# puts BusSchedule.new(data).calculate

schedule = Schedule.new(data)
schedule.iterate

puts "Part 2: #{schedule.current}"