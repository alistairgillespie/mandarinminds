class RemoveConfirmedFromLesson < ActiveRecord::Migration
  def change
  	remove_column :lessons, :confirmed
  	remove_column :notifications, :appear_at
  end
end
