class Day6
  DAYS_LEFT = 80

  def initialize
    @data = File.open('./data.txt').readlines.map(&:chomp).first.split(',').map(&:to_i)
    # @data = File.open('./sample_data.txt').readlines.map(&:chomp).first.split(',').map(&:to_i)
  end

  def call
    79.times do |n|
      0.upto(@data.length-1) do |i|
        next if @data[i] == 0
        @data[i] -= 1
        if @data[i] == 0
          @data += [7]
          @data += [9]
        end
      end
    end

    @data = @data.reject(&:zero?)

    @data.count
  end
end

p Day6.new.call