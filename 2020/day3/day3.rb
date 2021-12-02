require "./data"

def check_slope(x, y)
  tree_count = 0
  iteration = 0

  $data.each_with_index do |line, i|
    slope = x / y.to_f
    
    point = (slope * i)
    
    next if point != point.to_i # skip if x isn't a whole number (happens when y > 1)
    point = point.to_i

    if point / line.length > 0
      iteration = point / line.length
    end

    position = point - (iteration * line.length)

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