class Day5
  def initialize
    @data = File.open('./data.txt').readlines.map(&:chomp)
    # @data = File.open('./sample_data.txt').readlines.map(&:chomp)
    @instructions = {}
    build_instructions_hash
    @occupied_spaces = []
  end

  def round_1
    @instructions.each do |key, value|
      next unless horizontal_or_vertical?(value)

      xs = [value['x_1'], value['x_2']]
      ys = [value['y_1'], value['y_2']]
      if value['x_1'] != value['x_2']
        Array(xs.min..xs.max).each { |x| @occupied_spaces << [x, value['y_1']]}
      elsif value['y_1'] != value['y_2']
        Array(ys.min..ys.max).each { |y| @occupied_spaces << [value['x_1'], y]}
      end
    end
    p @occupied_spaces.group_by(&:itself).select { |k,v| v.length > 1 }.count
  end

  def round_2
    @instructions.each do |key, value|
      xs = [value['x_1'], value['x_2']]
      ys = [value['y_1'], value['y_2']]
      if value['x_1'] != value['x_2'] && value['y_1'] != value['y_2']
        if ((value['y_2'] - value['y_1']) / (value['x_2'] - value['x_1'])).positive?
          Array(xs.min..xs.max).each_with_index do |x, i|
            @occupied_spaces << [x, (ys.min + i)]
          end
        else
          Array(xs.min..xs.max).each_with_index do |x, i|
            @occupied_spaces << [x, (ys.max - i)]
          end
        end
      elsif value['x_1'] != value['x_2']
        Array(xs.min..xs.max).each { |x| @occupied_spaces << [x, value['y_1']]}
      elsif value['y_1'] != value['y_2']
        Array(ys.min..ys.max).each { |y| @occupied_spaces << [value['x_1'], y]}
      end
    end
    p @occupied_spaces.group_by(&:itself).select { |k,v| v.length > 1 }.count
  end

  def build_instructions_hash
    @data.each_with_index do |line, i|
      @instructions[i] = {}
      line
        .split(' -> ')
        .map.with_index { |a, j| @instructions[i]["x_#{j+1}"], @instructions[i]["y_#{j+1}"] = a.split(',').map(&:to_i) }
    end
  end

  def horizontal_or_vertical?(value)
    value['x_1'] == value['x_2'] || value['y_1'] == value['y_2']
  end
end


Day5.new.round_1
Day5.new.round_2