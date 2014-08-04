class AddStatusidToLesson < ActiveRecord::Migration
  def change
  	add_column :lessons, :status_id, :integer
  end
end
