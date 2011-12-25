class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.text    :phrase
      t.integer :yes_question_id, :null => true
      t.integer :no_question_id, :null => true

      t.timestamps
    end
  end
end
