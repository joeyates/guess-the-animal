class AddAnimalToQuestion < ActiveRecord::Migration
  def change
    add_column :questions, :animal, :text
  end
end
