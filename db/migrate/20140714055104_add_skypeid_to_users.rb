class AddSkypeidToUsers < ActiveRecord::Migration
  def change
    add_column :users, :skypeid, :string
  end
end
