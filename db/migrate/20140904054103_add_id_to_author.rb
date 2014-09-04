class AddIdToAuthor < ActiveRecord::Migration
  def change
  	rename_column :posts, :author, :author_id
  end
end
