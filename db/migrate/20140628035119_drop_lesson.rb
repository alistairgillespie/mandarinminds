class DropLesson < ActiveRecord::Migration
  def change
  	drop_table :lessons
  end
end
