rules = File.open("./data.txt").readlines

MY_BAG = "shiny gold"

total_shiny_gold_bags = 0
nested_bags_count = 0

rule_set = rules.map do |rule|
  key, value = rule.split(" bags contain ")
  value = value.split(", ")
  value = value.map do |v| 
    {
      name: key,
      count: v.split(" ")[0],
      contains: v.split(" ")[1..2].join(" ")
    }
  end
  [key, value]
end.to_h

puts rule_set.count

def find_shiny_gold(rule_set, value)
  return true if value.any? { |bag| bag[:contains] == MY_BAG }

  value.any? do |bag|
    next_value = rule_set[bag[:contains]]
    next if next_value.nil?
    find_shiny_gold(rule_set, next_value)
  end
end

def count_nested_bags(rule_set, top_level_bag)
  top_level_bag.map do |bag|
    if bag[:count].to_i == 0 # if bag contains no other bags return 0
      0
    else
      # (count nested bags
        # per number of top_level_bags)
      # plus the top_level_bags
      (count_nested_bags(rule_set, rule_set[bag[:contains]]) *
        bag[:count].to_i) +
      bag[:count].to_i
    end
  end.inject(:+)
end

rule_set.each do |key, value|
  total_shiny_gold_bags += 1 if find_shiny_gold(rule_set, value)
  nested_bags_count = count_nested_bags(rule_set, rule_set[MY_BAG])
end

puts total_shiny_gold_bags
puts nested_bags_count