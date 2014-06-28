class RenameLessonColumn < ActiveRecord::Migration
  def change
  		rename_column :lessons, :starting_time, :starts_at
  end
end
