require_relative '../day21.rb'

RSpec.describe Parser do
  describe "initialization" do
    it "initializes" do
      parser = Parser.new([])

      expect(parser).to be_an_instance_of Parser
    end

    it "initializes with data" do
      parser = Parser.new(["mxmxvkd kfcds sqjhc nhms (contains dairy, fish)"])

      expect(parser.recipes).to eq(["mxmxvkd kfcds sqjhc nhms (contains dairy, fish)"])
    end
  end

  describe "parse" do
    it "separates ingredients from allergens" do
      parser = Parser.new(["mxmxvkd kfcds sqjhc nhms (contains dairy, fish)"])
      ingredients, allergens = parser.parse(parser.recipes[0])

      expect(ingredients).to eq(["mxmxvkd", "kfcds", "sqjhc", "nhms"])
      expect(allergens).to eq(["dairy", "fish"])
    end
  end

  describe "match_allergens_to_ingredients" do
    it "allergens are matched with potential ingredients in one recipe" do
      recipes = [ "mxmxvkd kfcds sqjhc nhms (contains dairy, fish)" ]
      parser = Parser.new(recipes)
      ingredients, allergens = parser.parse(recipes[0])
      parser.match_allergens_to_ingredients(allergens, ingredients)

      expect(parser.allergen_hash).to eq({"dairy"=>["mxmxvkd", "kfcds", "sqjhc", "nhms"], "fish"=>["mxmxvkd", "kfcds", "sqjhc", "nhms"]})
    end

    it "allergens are matched with potential ingredients in multiple recipes" do
      recipes = [
        "mxmxvkd kfcds sqjhc nhms (contains dairy, fish)",
        "trh fvjkl sbzzf mxmxvkd (contains dairy)",
        "sqjhc fvjkl (contains soy)",
        "sqjhc mxmxvkd sbzzf (contains fish)"
      ]
      parser = Parser.new(recipes)
      ingredients, allergens = parser.parse_recipes

      expect(parser.allergen_hash).to eq({"dairy"=>["mxmxvkd"], "fish"=>["mxmxvkd", "sqjhc"], "soy"=>["sqjhc", "fvjkl"]})
    end
  end

  describe "count_nonallergenic_ingredients" do
    it "counts the nonallergenic ingredients" do
      recipes = [
        "mxmxvkd kfcds sqjhc nhms (contains dairy, fish)",
        "trh fvjkl sbzzf mxmxvkd (contains dairy)",
        "sqjhc fvjkl (contains soy)",
        "sqjhc mxmxvkd sbzzf (contains fish)"
      ]
      parser = Parser.new(recipes)
      ingredients, allergens = parser.parse_recipes
      parser.count_nonallergenic_ingredients

      expect(parser.count_nonallergenic_ingredients).to eq(5)
    end
  end

  describe "isolate_allergens" do
    it "prints the allergenic ingredients in alphabetical order" do
      recipes = [
        "mxmxvkd kfcds sqjhc nhms (contains dairy, fish)",
        "trh fvjkl sbzzf mxmxvkd (contains dairy)",
        "sqjhc fvjkl (contains soy)",
        "sqjhc mxmxvkd sbzzf (contains fish)"
      ]
      parser = Parser.new(recipes)
      ingredients, allergens = parser.parse_recipes
      isolated_hash = parser.isolate_allergens

      expect(isolated_hash).to eq({"dairy"=>["mxmxvkd"], "fish"=>["sqjhc"], "soy"=>["fvjkl"]})
    end
  end

  describe "ordered_allergenic_ingredients" do
    it "prints the allergenic ingredients in alphabetical order" do
      recipes = [
        "mxmxvkd kfcds sqjhc nhms (contains dairy, fish)",
        "trh fvjkl sbzzf mxmxvkd (contains dairy)",
        "sqjhc fvjkl (contains soy)",
        "sqjhc mxmxvkd sbzzf (contains fish)"
      ]
      parser = Parser.new(recipes)
      ingredients, allergens = parser.parse_recipes
      parser.count_nonallergenic_ingredients

      expect(parser.ordered_allergenic_ingredients).to eq("mxmxvkd,sqjhc,fvjkl")
    end
  end
end