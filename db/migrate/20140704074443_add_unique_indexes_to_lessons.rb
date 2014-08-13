class AddUniqueIndexesToLessons < ActiveRecord::Migration
  def change
  	add_index :lessons, ["teacher_id", "starts_at"], :unique => true
  	add_index :lessons, ["student_id", "starts_at"], :unique => true


  end
end
