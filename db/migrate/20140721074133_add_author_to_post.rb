class AddAuthorToPost < ActiveRecord::Migration
  def change
  	add_column :posts, :author, :integer
  end
end
