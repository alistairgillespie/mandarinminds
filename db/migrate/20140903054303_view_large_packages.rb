class ViewLargePackages < ActiveRecord::Migration
  def change
  	add_column :user_settings, :view_large_plans, :boolean
  end
end
