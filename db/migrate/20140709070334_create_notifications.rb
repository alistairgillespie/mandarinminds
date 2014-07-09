class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.references :user, index: true
      t.string :image
      t.text :content
      t.boolean :dismissed
      t.datetime :appear_at
      t.references :lesson, index: true

      t.timestamps
    end
  end
end
