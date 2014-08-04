class DropLessonStatus < ActiveRecord::Migration
  def change
  	drop_table :lesson_statuses
  end
end
