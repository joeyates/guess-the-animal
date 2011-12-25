class Question < ActiveRecord::Base
  belongs_to :yes_question, :class_name => 'Question'
  belongs_to :no_question,  :class_name => 'Question'

  validates :phrase, :presence => true
  validate :next_questions_valid

  def next_questions_valid
    if yes_question.present?
      if no_question.present?
        if yes_question == no_question
          errors.add( :yes_question, 'should be different to no question' )
        end
        if yes_question.phrase == no_question.phrase
          errors.add( :yes_question, 'should have different text to no question' )
        end
      else
        errors.add( :no_question, 'should be set if yes question is set' )
      end
    else
      if no_question.present?
        errors.add( :no_question, 'should not be set if yes question is not set' )
      end
    end
  end

end
