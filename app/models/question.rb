class Question < ActiveRecord::Base
  belongs_to :yes, :class_name => 'Question'
  belongs_to :no,  :class_name => 'Question'

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
      if ! yes.present?
        errors.add( :yes, 'should be set if a phrase is set' )
      end
      if ! no.present?
        errors.add( :no, 'should be set if a phrase is set' )
      end
    else
      if yes.present?
        errors.add( :yes, 'should not be set if a phrase is not set' )
      end
      if no.present?
        errors.add( :no, 'should not be set if a phrase is not set' )
      end
    end
  end

  def next_questions_valid
    if yes.present?
      if no.present?
        if yes == no
          errors.add( :yes, 'should be different to no question' )
        end
      else
        errors.add( :no, 'should be set if yes is set' )
      end
    else
      if no.present?
        errors.add( :no, 'should not be set if yes is not set' )
      end
    end
  end

end
