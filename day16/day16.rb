data = File.open("./data.txt").readlines
# data = File.open("./data-2.txt").readlines
# data = File.open("./data-3.txt").readlines

class ParseTickets
  attr_accessor :rules, :my_ticket, :nearby_tickets, :invalid_tickets, :valid_tickets
  
  def initialize(data)
    build_data(data)
  end

  def build_data(data)
    rules, my_ticket, nearby_tickets = data.join("").split("\n\n").map {|section| section.split("\n")}
    build_rules(rules)
    build_my_ticket(my_ticket)
    build_neary_tickets(nearby_tickets)
    @invalid_tickets = find_invalid_tickets
    @valid_tickets = find_valid_tickets
  end

  def build_rules(rules)
    @rules = rules
      .each_with_object({}) { |rule, acc| acc[rule.split(": ")[0]] = rule.split(": ")[1].split(" or ").map { |range| range.split("-").map(&:to_i) } }
  end

  def build_my_ticket(my_ticket)
    @my_ticket = my_ticket[1].split(",").map(&:to_i)
  end

  def build_neary_tickets(nearby_tickets)
    @nearby_tickets = nearby_tickets[1..-1].map { |ticket| ticket.split(",").map(&:to_i) }
  end

  def ticket_value_between_rules?(tv, rv)
    tv.between?(rv[0][0], rv[0][1]) || tv.between?(rv[1][0], rv[1][1])
  end

  def find_invalid_tickets
    invalid_tickets = []
    @nearby_tickets.each_with_index do |ticket, i|
      ticket.each do |tv|
        invalid_tickets << {i => tv} if !@rules.values.any? { |rv| ticket_value_between_rules?(tv, rv) }
      end
    end
    invalid_tickets.inject({}, :merge)
  end

  def find_valid_tickets
    @nearby_tickets.select.with_index do |ticket, i|
      !@invalid_tickets.keys.include?(i)
    end
  end

  def find_invalid_positions_per_field
    @rules.each_with_object({}) do |(name, ranges), acc|
      @valid_tickets[0].length.times do |n|
        if !@valid_tickets.all? { |vt| ticket_value_between_rules?(vt[n], ranges) }
          acc[name] ||= []
          acc[name] << n
        end
      end
    end
  end

  def find_field_values
    all_positions = (0..@valid_tickets[0].length - 1).to_a
    remaining_positions = all_positions
    find_invalid_positions_per_field
      .sort_by { |k, v| -v.length }
      .map { |item| 
        position = { item[0] => remaining_positions - item[1] }
        remaining_positions -= position.values.flatten
        position
      }
      .inject({}, :merge)
      .select { |k, v| k.match(/departure/) }
      .values
      .flatten
  end

  def find_my_ticket_value
    find_field_values.inject(1) { |product, pos| product *= @my_ticket[pos] }
  end
end

p ParseTickets.new(data).invalid_tickets.values.sum
p ParseTickets.new(data).find_my_ticket_value
