class Question < ActiveRecord::Base
  belongs_to :yes_question, :class_name => 'Question'
  belongs_to :no_question,  :class_name => 'Question'

  validate :next_questions_valid

  def next_questions_valid
    if yes_question.present?
      if no_question.present?
        if yes_question == no_question
          errors.add( :yes_question, 'should be different to no_question' )
          errors.add( :no_question, 'should be different to yes_question' )
        end
      else
        errors.add( :no_question, 'should be set if yes_question is set' )
      end
    else
      if no_question.present?
        errors.add( :no_question, 'should not be set if yes_question is not set' )
      end
    end
  end

end
