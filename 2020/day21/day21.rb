data = File.open("./data.txt").readlines
# data = File.open("./data-2.txt").readlines

# Create list of allergens
# Create hash with ingredients pointing to potential allergens
# When an allergen is listed but a potential ingredient is not, drop that allergen from the potential ingredient

class Parser
  attr_accessor :recipes, :allergen_hash, :ingredients

  def initialize(recipes)
    @recipes = recipes
    @ingredients = []
    @allergen_hash = {}
  end

  def parse_recipes
    @recipes.each do |recipe|
      ingredients, allergens = parse(recipe)
      @ingredients += ingredients
      match_allergens_to_ingredients(allergens, ingredients)
    end
  end

  def parse(recipe)
    ingredient_string, allergen_string = recipe.strip.split(" (contains ")
    ingredients = ingredient_string.split(" ")
    allergens = allergen_string.gsub(")", "").split(", ")
    [ingredients, allergens]
  end

  def ordered_allergenic_ingredients
    isolate_allergens
      .sort
      .map {|item| item[1]}
      .flatten
      .join(",")
  end

  def count_nonallergenic_ingredients
    allergenic_ingredients = @allergen_hash.values.flatten.uniq
    @ingredients.count { |ingredient| !allergenic_ingredients.include?(ingredient) }
  end

  def match_allergens_to_ingredients(allergens, ingredients)
    allergens.each do |allergen|
      if @allergen_hash[allergen]
        @allergen_hash[allergen] = @allergen_hash[allergen] & ingredients
      else
        @allergen_hash[allergen] = ([] + ingredients)
      end
    end
  end

  def isolate_allergens
    isolated_hash = {}
    until isolated_hash.length == @allergen_hash.length
      @allergen_hash.each do |k, v|
        spoken_for_allergens = isolated_hash.values.flatten
        if (v - spoken_for_allergens).length == 1
          isolated_hash[k] = v - spoken_for_allergens
        end
      end
    end
    isolated_hash
  end
end

parser = Parser.new(data)
parser.parse_recipes

puts "Part 1: #{parser.count_nonallergenic_ingredients}"
puts "Part 2: #{parser.ordered_allergenic_ingredients}"