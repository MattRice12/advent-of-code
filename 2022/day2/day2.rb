class PRS
  SCORES = { lose: 0, tie: 3, win: 6 }

  TRANSLATE_1 = { a: :rock, x: :rock, b: :paper, y: :paper, c: :scissors, z: :scissors }
  TRANSLATE_2 = { a: :rock, x: :lose, b: :paper, y: :tie, c: :scissors, z: :win }

  WIN = { rock: :scissors, paper: :rock, scissors: :paper }
  TIE = { rock: :rock, paper: :paper, scissors: :scissors }
  LOSE = { rock: :paper, paper: :scissors, scissors: :rock }

  CHOICE_BONUS = { rock: 1, paper: 2, scissors: 3 }

  OUTCOMES = { win: WIN, tie: TIE, lose: LOSE }

  attr_reader :data, :score

  def initialize
    @data = File.open("./data.txt").readlines
    @score = 0
  end

  def round_1
    data.each do |round|
      p1, p2 = round.strip.split(" ").map(&:downcase).map(&:to_sym).map {|letter| TRANSLATE_1[letter]}

      @score += SCORES[:win]  + CHOICE_BONUS[p2] if WIN[p2] == p1
      @score += SCORES[:tie]  + CHOICE_BONUS[p2] if TIE[p2] == p1
      @score += SCORES[:lose] + CHOICE_BONUS[p2] if LOSE[p2] == p1
    end

    score
  end

  def round_2
    data.each do |round|
      p1, p2 = round.strip.split(" ").map(&:downcase).map(&:to_sym).map {|letter| TRANSLATE_2[letter]}

      outcome = OUTCOMES[p2]

      @score += SCORES[p2] + CHOICE_BONUS[outcome.invert[p1]]
    end

    score
  end
end

puts PRS.new.round_1
puts PRS.new.round_2
