require "./data"

def check_slope(x, y)
  tree_count = 0
  iteration = 0

  $data.each_with_index do |line, i|
    slope = x / y.to_f
    
    start = (i * slope).to_i
    
    next if (slope * i) != start # skip if slope doesn't hit a vertex on the grid

    if start / line.length > 0
      iteration = start / line.length
    end

    position = start - (iteration * line.length)

    tree_count += 1 if line[position] == "#"
  end
  tree_count
end

puts [
  check_slope(1, 1),
  check_slope(3, 1),
  check_slope(5, 1),
  check_slope(7, 1),
  check_slope(1, 2)
].inject(1, :*)