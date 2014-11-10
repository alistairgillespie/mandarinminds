class AddIndexToLessons < ActiveRecord::Migration
  def change
  	add_index(:lessons, [:starts_at, :teacher_id])
  end
end
