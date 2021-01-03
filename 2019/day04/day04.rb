data = File.open("./data.txt").readlines.join("")


class PasswordValidator
  attr_accessor :passwords

  PASSWORD_LENGTH = 6

  def initialize(data)
    passwords = data.split("-").map(&:to_i)
    @passwords = (passwords[0]..passwords[1]).to_a
  end

  def count_valid_passwords
    @passwords.count do |password| 
      has_valid_length?(password) &&
        has_adjacent_digits?(password) &&
        has_incrementing_digits?(password)
    end
  end

  def count_valid_passwords_part_2
    @passwords.count do |password|
      has_valid_length?(password) &&
        has_adjacent_digits?(password) &&
        has_incrementing_digits?(password) &&
        has_group_of_two?(password)
    end
  end

  def has_valid_length?(password)
    password.to_s.length == PASSWORD_LENGTH
  end

  def has_adjacent_digits?(password)
    password_arr = password.to_s.split("")
    password_arr.each_with_index.any? { |char, i| char == password_arr[i+1] }
  end

  def has_group_of_two?(password)
    password
      .to_s
      .split("")
      .each_with_object({}) { |char, acc|
        acc[char] ||= 0
        acc[char] += 1
      }
      .any? { |k, v| v == 2 }
  end

  def has_incrementing_digits?(password)
    password_arr = password.to_s.split("").map(&:to_i)
    password_arr.each_with_index.all? do |char, i| 
      return true if password_arr[i+1] == nil
      char <= password_arr[i+1]
    end
  end
end

# validator = PasswordValidator.new(data)
# p "Part 1: #{validator.count_valid_passwords}"

validator = PasswordValidator.new(data)
p "Part 2: #{validator.count_valid_passwords_part_2}"