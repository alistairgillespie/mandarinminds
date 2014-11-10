class RemoveLessonIndex < ActiveRecord::Migration
  def change
  	remove_index(:lessons, :name => 'index_lessons_on_starts_at_and_student_id')
  	remove_index(:lessons, :name => 'index_lessons_on_starts_at_and_teacher_id')
  	remove_index(:lessons, :name => 'index_lessons_on_student_id_and_starts_at')
  	remove_index(:lessons, :name => 'index_lessons_on_student_id')
  end
end
