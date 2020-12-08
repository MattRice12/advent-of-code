# rules = File.open("./data.txt").readlines
rules = File.open("./data-2.txt").readlines

# 1) keep track of all the `jmp`s and `nop`s
# 2) run the program until an infinite loop is hit
# 3) change the first jpm/nop and run the program again until infinite loop
# 4) change the nth jpm/nop and run program again until infinite loop
# 5) repeat 4 until success

rules_used = []

acc = 0
index = 0

attempt = 0

potential_errors = []

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

  puts "index=#{index}"
  puts "rule=#{hashed_rules[index]}"

  error, argument = hashed_rules[index].split(" ")
  if error == "jmp"
    error = "nop"
  elsif error == "nop"
    error = "jmp"
  end
  next_hashed_rules = hashed_rules.dup
  next_hashed_rules[index] = "#{error} #{argument}"

  puts next_hashed_rules

  next_hashed_rules
end

while index < rules.length do
  operation, argument = next_hashed_rules[index].split(" ")
  rules_used.push(index)
  
  if rules_used.length != rules_used.uniq.length
    attempt += 1
    puts
    puts "attempt=#{attempt}"
    acc = 0
    index = 0
    puts "rules_used=#{rules_used}"
    rules_used = []
    puts potential_errors
    next_error = potential_errors.find { |error| !error[:changed] }
    puts "$$$#{next_error}"
    next_error[:changed] = true
    next_hashed_rules = swap_operator(hashed_rules, next_error)
  else
    case operation
    when "acc" then acc += argument.to_i
    when "jmp" 
      index += argument.to_i - 1
    when "nop"
    end
    index += 1
  end
end

puts acc