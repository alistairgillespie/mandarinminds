module ApplicationHelper
	def resource_name
		:user
	end
	
	def resource
		@resource ||= User.new
	end
	
	def devise_mapping
		@devise_mapping ||= Devise.mappings[:user]
	end
	
	#Is this needed?
	def resource_class
		User
	end

	def typekit_include_tag apikey
  		javascript_include_tag("http://use.typekit.com/#{apikey}.js") +
  		javascript_tag("try{Typekit.load()}catch(e){}")
	end
	
end
