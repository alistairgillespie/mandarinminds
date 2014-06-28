class FixColumnName < ActiveRecord::Migration
  def change
  	rename_column :lessons, :starts_at, :starting_time
  end
end
