class AddLessonIndexes < ActiveRecord::Migration
  def change
  	add_index :lessons, [:starts_at, :student_id]
  	add_index :lessons, [:starts_at, :teacher_id]
  end
end
