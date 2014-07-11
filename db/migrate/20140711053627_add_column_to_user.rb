class AddColumnToUser < ActiveRecord::Migration
  def change
  	add_column :users, :lesson_count, :integer
  end
end
