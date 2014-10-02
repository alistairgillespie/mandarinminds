class CreateTeachers < ActiveRecord::Migration
  def change
    create_table :teachers do |t|
      t.integer :user_id
      t.text :description
      t.boolean :show_on_page
      t.boolean :show_in_dropdown

      t.timestamps
    end
  end
end
