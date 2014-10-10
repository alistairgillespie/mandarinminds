class AddStudentIndexToLessons < ActiveRecord::Migration
  def change
  	add_index(:lessons, [:starts_at, :student_id])
  end
end
