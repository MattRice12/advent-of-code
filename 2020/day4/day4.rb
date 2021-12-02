data = File.open("./data.txt").readlines


codes = [ "byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid", "cid" ]
optional_code = ["cid"]

valid_count = 0

passports = data.join("").split("\n\n")

def all_codes_present?(keys, codes, optional_code)
  (keys | optional_code).length == codes.length
end

def all_fields_valid?(fields_hash)
  fields_hash.all? do |key, value|
    case key
    when "byr" then value.length == 4 && value.to_i.between?(1920, 2002)
    when "iyr" then value.length == 4 && value.to_i.between?(2010, 2020)
    when "eyr" then value.length == 4 && value.to_i.between?(2020, 2030)
    when "hgt" then value.match(/^(([1][5-8][0-9]|[1][9][0-3])(cm)|([5][9]|[6][0-9]|[7][0-6])(in))+/)
    when "hcl" then value.match(/^#[0-9a-f]{6}$/)
    when "ecl" then value.match(/(amb|blu|brn|gry|grn|hzl|oth){1}/)
    when "pid" then value.match(/^[0-9]{9}$/)
    else
      true
    end
  end
end

def passport_valid?(fields, codes, optional_code)
  all_codes_present?(fields.keys, codes, optional_code) && all_fields_valid?(fields)
end

passports.each do |passport|
  fields = passport.split(/\s/)
                   .flat_map { |field| Hash[*field.split(":")] }
                   .inject(:merge)
  valid_count += 1 if passport_valid?(fields, codes, optional_code)
end

puts valid_count
