class RenameStripeEvent < ActiveRecord::Migration
  def change
  	rename_table :stripe_events, :stripe_webhooks
  end
end
