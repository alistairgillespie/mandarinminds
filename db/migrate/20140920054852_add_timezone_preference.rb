class AddTimezonePreference < ActiveRecord::Migration
  def change
  	add_column :users, :timezone_offset, :integer
  end
end
