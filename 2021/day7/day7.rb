class Day7
  def initialize
    @data = File.open('./data.txt').readlines.first.split(',').map(&:to_i)
    # @data = File.open('./sample_data.txt').readlines.first.split(',').map(&:to_i)
  end

  def part_1
    total = 0
    (@data.min..@data.max).each do |p1|
      subtotal = 0
      @data.each { |p2| subtotal += (p2 - p1).abs }
      total = subtotal if subtotal < total || total == 0
    end
    total
  end

  def part_2
    total = 0
    (@data.min..@data.max).each do |p1|
      subtotal = 0
      @data.each do |p2|
        steps = (p2 - p1).abs
        subtotal += nth_triangle(steps)
      end
      total = subtotal if subtotal < total || total == 0
    end
    total
  end

  def nth_triangle(n)
    (n**2 + n) / 2
  end
end

p Day7.new.part_1
p Day7.new.part_2
