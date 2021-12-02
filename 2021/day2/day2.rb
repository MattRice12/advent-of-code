class Navigation
  attr_accessor :data, :x, :y, :aim

  def initialize
    @data = File.open('./data.txt').readlines
    @x = 0
    @y = 0
    @aim = 0
  end

  def move
    @data.each do |instruction|
      direction, distance = instruction.split(' ')

      case direction
      when 'forward' then @x += distance.to_i
      when 'down' then @y += distance.to_i
      when 'up' then @y -= distance.to_i
      end
    end

    x * y
  end

  def target
    @data.each do |instruction|
      direction, distance = instruction.split(' ')

      case direction
      when 'forward' then move_forward(distance.to_i)
      when 'down' then @aim += distance.to_i
      when 'up' then @aim -= distance.to_i
      end
    end

    x * y
  end

  def move_forward(distance)
    @x += distance.to_i
    @y += distance.to_i * @aim
  end
end

puts Navigation.new.move
puts Navigation.new.target