class RemoveIndexesAgain < ActiveRecord::Migration
  def change
  	remove_index(:lessons, :name => 'index_lessons_on_starts_at_and_student_id')
  	remove_index(:lessons, :name => 'index_lessons_on_starts_at_and_teacher_id')
  end
end
