data = File.open("./data.txt").readlines

class Questionnaire
  attr_accessor :total_questions_answered

  def initialize(data)
    @groups = data.join("").split("\n\n")
    @total_questions_answered = 0
    @total_questions_answered_by_all = 0
  end


  def present_total_questions_answered
    sum_questions_answered
    @total_questions_answered
  end

  def present_total_questions_answered_by_all
    sum_questions_answered_by_all
    @total_questions_answered_by_all
  end

  private
  
  def sum_questions_answered
    @groups.each do |group|
      questions = group.split("\n")
      questions_answered = questions.join().split("").uniq
      @total_questions_answered += questions_answered.length
    end
  end

  def sum_questions_answered_by_all
    @groups.each do |group|
      participants = group.split("\n")
      answers = group_answers_by_count(participants)
      unanimous_answers = select_only_questions_everyone_answered(answers, participants)
      @total_questions_answered_by_all += unanimous_answers.length
    end
  end

  def group_answers_by_count(participants)
    participants.each_with_object(Hash.new(0)) { |answer_set, acc| count_answers(answer_set, acc) }
  end

  def count_answers(answer_set, acc)
    answer_set.split("").each { |answer| acc[answer] += 1 }
  end

  def select_only_questions_everyone_answered(answers, participants)
    answers.select { |item| answers[item] == participants.length }.keys
  end
end

questionnaire = Questionnaire.new(data)
puts "Questions Answered - #{questionnaire.present_total_questions_answered}"
puts "Questions Answered By All - #{questionnaire.present_total_questions_answered_by_all}"



