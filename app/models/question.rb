class Question < ActiveRecord::Base
  belongs_to :yes_question, :class_name => 'Question'
  belongs_to :no_question,  :class_name => 'Question'

  validates :animal, :uniqueness => { :message => 'has already been added' }
  validates :phrase, :format => { :with => /\?$/, :message => 'should be a question' },
                     :allow_nil => true
  validate :animal_or_phrase
  validate :phrase_and_questions
  validate :next_questions_valid

  def animal_or_phrase
    if animal.present?
      if phrase.present?
        errors.add( :animal, 'should not be set if animal is set' )
      end
    else
      if ! phrase.present?
        errors.add( :animal, 'and phrase can\'t both be blank' )
      end
    end
  end

  def phrase_and_questions
    if phrase.present?
      if ! yes_question.present?
        errors.add( :yes_question, 'should be set if a phrase is set' )
      end
      if ! no_question.present?
        errors.add( :no_question, 'should be set if a phrase is set' )
      end
    else
      if yes_question.present?
        errors.add( :yes_question, 'should not be set if a phrase is not set' )
      end
      if no_question.present?
        errors.add( :no_question, 'should not be set if a phrase is not set' )
      end
    end
  end

  def next_questions_valid
    if yes_question.present?
      if no_question.present?
        if yes_question == no_question
          errors.add( :yes_question, 'should be different to no question' )
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
