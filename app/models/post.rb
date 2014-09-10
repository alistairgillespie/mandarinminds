class Post < ActiveRecord::Base
	def self.POSTS_PER_PAGE
		5
	end

	belongs_to :author, :class_name => 'User', inverse_of: :posts
end
