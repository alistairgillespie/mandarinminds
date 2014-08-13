class CreatePlans < ActiveRecord::Migration
  def change
    create_table :plans do |t|
      t.string :name
      t.integer :price
      t.integer :lessons
      t.integer :duration
      t.integer :expiry_time

      t.timestamps
    end
  end
end
