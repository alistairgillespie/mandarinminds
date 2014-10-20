class AddMoreIndexes < ActiveRecord::Migration
  def change
  	add_index(:charges, :user_id)
  	add_index(:posts, :author_id)
  	add_index(:teachers, :user_id)
  	add_index(:user_settings, :user_id)
  	add_index(:users, :stripe_id)
  end
end
