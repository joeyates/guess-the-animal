class Question < ActiveRecord::Base
  belongs_to :yes_question, :class_name => 'Question'
  belongs_to :no_question,  :class_name => 'Question'
end
