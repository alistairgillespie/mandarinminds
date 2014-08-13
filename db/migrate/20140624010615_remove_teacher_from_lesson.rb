class RemoveTeacherFromLesson < ActiveRecord::Migration
  def change
    remove_reference :lessons, :teacher, index: true
  end
end
