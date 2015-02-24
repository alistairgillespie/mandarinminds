class AddTotalLessonsToUser < ActiveRecord::Migration
  def change
  	add_column :users, :total_lessons_bought, :integer
  end
end
