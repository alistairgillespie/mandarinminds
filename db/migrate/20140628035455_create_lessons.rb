class CreateLessons < ActiveRecord::Migration
  def change
    create_table :lessons do |t|
      t.references :student, index: true
      t.references :teacher, index: true
      t.datetime :starting_time

      t.timestamps
    end
  end
end
