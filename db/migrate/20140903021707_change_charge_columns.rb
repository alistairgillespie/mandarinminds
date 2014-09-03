class ChangeChargeColumns < ActiveRecord::Migration
  def change
  	remove_column :charges, :plan_id
  	add_column :charges, :description, :string
  end
end
