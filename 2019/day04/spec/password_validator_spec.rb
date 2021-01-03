require_relative '../day04.rb'

RSpec.describe PasswordValidator do
  DATA = "456788-456792"

  describe "initialization" do
    it "initializes" do
      validator = PasswordValidator.new(DATA)

      expect(validator).to be_an_instance_of PasswordValidator
    end

    it "builds passwords" do
      validator = PasswordValidator.new(DATA)

      expect(validator.passwords).to eq([456788, 456789, 456790, 456791, 456792])
    end
  end

  describe "validates password" do
    describe "password must be six digits" do
      it "password that is six digits is valid" do
        validator = PasswordValidator.new(DATA)
        password = 456788

        expect(validator.has_valid_length?(password)).to eq(true)
      end

      it "password that is less than six digits is not valid" do
        validator = PasswordValidator.new(DATA)
        password = 4567

        expect(validator.has_valid_length?(password)).to eq(false)
      end

      it "password that is more than six digits is not valid" do
        validator = PasswordValidator.new(DATA)
        password = 45678888

        expect(validator.has_valid_length?(password)).to eq(false)
      end
    end
    
    describe "adjacent digits" do
      it "password with two adjacent digits that are the same is valid" do
        validator = PasswordValidator.new(DATA)
        password = 456788

        expect(validator.has_adjacent_digits?(password)).to eq(true)
      end

      it "password with no two adjacent digits that are the same is not valid" do
        validator = PasswordValidator.new(DATA)
        password = 456789

        expect(validator.has_adjacent_digits?(password)).to eq(false)
      end
    end

    describe "incrementing digits" do
      it "subsequent password digits that are the same are valid" do
        validator = PasswordValidator.new(DATA)
        password = 444444

        expect(validator.has_incrementing_digits?(password)).to eq(true)
      end

      it "subsequent password digits that are the higher are valid" do
        validator = PasswordValidator.new(DATA)
        password = 444445

        expect(validator.has_incrementing_digits?(password)).to eq(true)
      end

      it "subsequent password digits that are lower are invalid valid" do
        validator = PasswordValidator.new(DATA)
        password = 444443

        expect(validator.has_incrementing_digits?(password)).to eq(false)
      end
    end

    describe "digit groups" do
      it "password with a group of only two digits is valid" do
        validator = PasswordValidator.new(DATA)
        password = 444455

        expect(validator.has_group_of_two?(password)).to eq(true)
      end

      it "password without a group of only two digits is invalid" do
        validator = PasswordValidator.new(DATA)
        password = 444456

        expect(validator.has_group_of_two?(password)).to eq(false)
      end
    end

    describe "sequence of passwords" do
      it "count valid passwords" do
        validator = PasswordValidator.new(DATA)

        expect(validator.count_valid_passwords).to eq(1)
      end
    end
  end
end