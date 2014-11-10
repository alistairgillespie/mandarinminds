class AddIndexesAgain < ActiveRecord::Migration
  def change
  	add_index(:lessons, [:starts_at, :teacher_id])
  	add_index(:lessons, [:starts_at, :student_id])
  end
end
