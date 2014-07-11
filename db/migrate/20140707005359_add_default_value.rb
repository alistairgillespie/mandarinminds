class AddDefaultValue < ActiveRecord::Migration
  def change
  	change_column :notifications, :dismissed, :boolean, :default => false
  end
end
