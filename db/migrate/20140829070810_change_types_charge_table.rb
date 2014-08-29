class ChangeTypesChargeTable < ActiveRecord::Migration
  def change
  	    change_column :charges, :user_id, 'integer USING CAST(user_id AS integer)'
  end
end
