class OneLastIndexChangeRedux < ActiveRecord::Migration
  def change
  	remove_index(:lessons, :name => 'index_lessons_on_starts_at_and_student_id')
  	remove_index(:lessons, :name => 'index_lessons_on_starts_at_and_teacher_id')
  	add_index(:lessons, [:starts_at, :teacher_id], unique: true)
  	add_index(:lessons, [:starts_at, :student_id], unique: true)
  end
end
