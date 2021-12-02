rules = File.open("./data.txt").readlines
# rules = File.open("./data-2.txt").readlines

time = Time.now

rules_used = []
potential_errors = []

acc = 0
index = 0


loops = 0

hashed_rules = rules.map.with_index do |rule, index|
  operator, _ = rule.split(" ")
  if ["jmp", "nop"].include?(operator )
    potential_errors << { operator: operator, index: index, changed: false }
  end
  { index => rule }
end.reduce({}, :merge)

next_hashed_rules = hashed_rules.dup

def swap_operator(hashed_rules, next_error)
  index = next_error[:index]
  error, argument = hashed_rules[index].split(" ")
  if error == "jmp"
    error = "nop"
  elsif error == "nop"
    error = "jmp"
  end
  next_hashed_rules = hashed_rules.dup
  next_hashed_rules[index] = "#{error} #{argument}"

  next_hashed_rules
end

while index < rules.length do
  loops += 1
  operation, argument = next_hashed_rules[index].split(" ")
  rules_used.push(index)
  
  if rules_used.length != rules_used.uniq.length
    acc = 0
    index = 0
    rules_used = []
    next_error = potential_errors.find { |error| !error[:changed] }
    next_error[:changed] = true
    next_hashed_rules = swap_operator(hashed_rules, next_error)
  else
    case operation
    when "acc" then acc += argument.to_i
    when "jmp" then index += argument.to_i - 1
    when "nop"
    end
    index += 1
  end
end

puts loops
puts Time.now - time

puts acc