class AddDetailsToLesson < ActiveRecord::Migration
  def change
    add_column :lessons, :student_id, :integer
    add_column :lessons, :teacher_id, :integer
  end

  add_index :lessons, [:student_id, :teacher_id]
end
