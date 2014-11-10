class Teacher < ActiveRecord::Base
	validates :user_id, uniqueness: true
	validates :abbr, 
		:format => { with: /\A[a-zA-Z]+\z/, message: "Abbreviation must only be letters. No spaces allowed" },
    	:presence => {message: "You must provide the one-word abbreviation for this teacher."}, 
    	on: :update
end
