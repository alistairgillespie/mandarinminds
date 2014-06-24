class RemoveStudentFromLesson < ActiveRecord::Migration
  def change
    remove_reference :lessons, :student, index: true
  end
end
