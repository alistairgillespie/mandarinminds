class ChangeTimestampToInteger < ActiveRecord::Migration
  def change
  	remove_column :user_settings, :dudu_expiry_timestamp
  	add_column :user_settings, :dudu_expiry_timestamp, :integer
  end
end
