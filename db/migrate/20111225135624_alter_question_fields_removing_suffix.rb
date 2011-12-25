class AlterQuestionFieldsRemovingSuffix < ActiveRecord::Migration
  def up
    change_table( :questions ) do |t|
      t.remove :yes_question_id
      t.remove :no_question_id
      t.integer :yes_id, :null => true
      t.integer :no_id, :null => true
    end
  end

  def down
    change_table( :questions ) do |t|
      t.remove :yes_id
      t.remove :no_id
      t.integer :yes_question_id, :null => true
      t.integer :no_question_id, :null => true
    end
  end

end
