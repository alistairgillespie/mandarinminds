class CreateUserSettings < ActiveRecord::Migration
  def change
    create_table :user_settings do |t|
      t.integer :user_id
      t.boolean :purchased_dudu
      t.boolean :receive_morning_emails

      t.timestamps
    end
  end
end
