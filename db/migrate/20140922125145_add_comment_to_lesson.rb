class AddCommentToLesson < ActiveRecord::Migration
  def change
  	add_column :lessons, :comment, :text
  end
end
