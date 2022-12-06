class Day12

  def initialize
    # @data = File.open('./data.txt').readlines.map(&:chomp)
    @data = File.open('./sample_data.txt').readlines.map(&:chomp)
    # @data = File.open('./sample_data_2.txt').readlines.map(&:chomp)
  end

  def part_1
    hashmap = build_cave_system
    paths = []
    p hashmap
    hashmap['start'].each do |cave|
      paths << navigate(hashmap, cave, ['start', cave])
    end
    paths
  end

  def navigate(hashmap, source_cave, path)
    hashmap[source_cave].each do |cave|
      next if path.include?(cave) && /[a-z]/.match(cave)
      return path + ['end'] if /(end)/.match(cave)

      navigate(hashmap, cave, path << cave)
    end
    path
  end

  def build_cave_system
    @data.inject({}) do |acc, instruction|
      a, b = instruction.split('-')
      acc[a] ||= []
      acc[b] ||= []
      if /(start)|(end)/.match(a)
        acc[a] << b
      else
        acc[a] << b
        acc[b] << a
      end
      acc
    end
  end

  def part_2
  end

end

p Day12.new.part_1
p Day12.new.part_2