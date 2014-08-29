class CreateCharges < ActiveRecord::Migration
  def change
    create_table :charges do |t|
      t.string :user_id
      t.string :sale_id
      t.integer :plan_id

      t.timestamps
    end
  end
end
