class Charge < ActiveRecord::Base
	belongs_to :user, :class_name => 'User', inverse_of: :charges
	before_create :populate_sale_id

	private
	def populate_sale_id
		self.sale_id = SecureRandom.uuid()
	end

	def purchase_summary
		@purchases = Charge.where("created_at > ? AND created_at < ?", Time.now.in_time_zone("Perth").beginning_of_day - 1.day, Time.now.in_time_zone("Perth").beginning_of_day).order(created_at: :asc)
		if @purchases.size > 0
			Notifier.purchase_summary(@purchases).deliver!
		end
	end
end
