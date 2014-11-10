class AddDuduExpiry < ActiveRecord::Migration
  def change
  	add_column :user_settings, :dudu_expiry_timestamp, :string
  end
end
