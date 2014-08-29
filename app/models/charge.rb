class Charge < ActiveRecord::Base
	belongs_to :plan
	before_create :populate_sale_id

	private
	def populate_sale_id
		self.sale_id = SecureRandom.uuid()
	end
end
