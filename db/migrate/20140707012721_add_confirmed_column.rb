class AddConfirmedColumn < ActiveRecord::Migration
  def change
  	add_column :lessons, :confirmed, :boolean, :default => false
  end
end
