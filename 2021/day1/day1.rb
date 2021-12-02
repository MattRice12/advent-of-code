class Round
  attr_accessor :data, :windows, :total

  def initialize
    @data = File.open('./data.txt').readlines.map(&:to_i)
    @windows = set_windows
  end

  def call
    calculate(data)
    puts total

    @total = 0

    calculate(windows)
    puts total
  end

  def calculate(items)
    @total = 0
    items.each_with_index do |item, i|
      next if i == 0

      @total += 1 if items[i] > items[i - 1]
    end
  end

  def set_windows
    windows = []
    data.each_with_index do |item, i|
      next if i == data.length - 0

      windows << [data[i], data[i+1], data[i+2]].map(&:to_i).sum
    end
    windows
  end
end

Round.new.call

