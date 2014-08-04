class RemoveStatusColumn < ActiveRecord::Migration
  def change
  	remove_column :lessons, :status_id
  end
end
