data = File.open("./data.txt").readlines
# data = File.open("./data-2.txt").readlines

class Machine
  attr_accessor :code_hash

  TARGET = 19_690_720

  def initialize(data)
    @data = data.join("").split(",")
    @code_hash = {}
    build_code_hash
  end

  def build_code_hash
    @data.each_with_index do |code, i|
      @code_hash[i] = code.to_i
    end
  end

  def reset_code_hash
    build_code_hash
  end

  def pre_run(first, second)
    @code_hash[1] = first
    @code_hash[2] = second
  end

  def find_parameters
    0.upto(@data.length-1) do |first|
      0.upto(@data.length-1) do |second|
        reset_code_hash
        pre_run(first, second)
        run
        return if output_opcode == TARGET
      end
    end
  end

  def run
    0.upto(@data.length/4) { |n| calculate_opcode(n) }
  end

  def calculate_opcode(n)
    opcode, first, second, output = *(n*4..n*4+3)

    @code_hash[@code_hash[output]] = 
      case @code_hash[opcode]
      when 1 then @code_hash[@code_hash[first]] + @code_hash[@code_hash[second]]
      when 2 then @code_hash[@code_hash[first]] * @code_hash[@code_hash[second]]
      when 99 then return
    end
  end

  def output_opcode
    @code_hash.values[0]
  end

  def output_parameters
    100 * @code_hash.values[1] + @code_hash.values[2]
  end
end

machine = Machine.new(data)
machine.pre_run(12, 2)
machine.run
p "Part 1: #{machine.output_opcode}"


machine2 = Machine.new(data)
machine2.find_parameters
p "Part 2: #{machine2.output_parameters}"