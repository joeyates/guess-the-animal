class Question < ActiveRecord::Base
  belongs_to :yes, :class_name => 'Question'
  belongs_to :no,  :class_name => 'Question'

  # Validations

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

  # Operations

  def insert_question( phrase, new_animal )
    old_animal = animal
    Question.connection.transaction do
      # Temporarily change name to allow us to create a new question
      # TODO: find a more elegant way to do this
      update_attributes!( :animal => self.class.unique_animal )
      yes = Question.create!( :animal => new_animal )
      no  = Question.create!( :animal => old_animal )
      update_attributes!( :phrase => phrase,
                          :animal => nil,
                          :yes    => yes,
                          :no     => no )
    end
  end

  def self.unique_animal
    ( 'A' .. 'Z' ).to_a.each do | name |
      while name.length <= 20
        return name if find_by_animal( name ) == nil
        name += 'a'
      end
    end

    raise 'All generable names exist'
  end

end
