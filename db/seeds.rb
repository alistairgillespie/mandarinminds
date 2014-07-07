# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

teachers = [
	["Esther", "Ma", "esther@mm.com", "12345678", 2],
	["Joan", "Zhou", "joan@mm.com", "12345678", 2],
	["Minnie", "Dong", "minnie@mm.com", "12345678", 2]
]

['student', 'teacher', 'moderator', 'admin'].each do |role|
  Role.where(name: role).first_or_create
end

teachers.each do |firstname, lastname, email, password, role_id|
	user = User.new
	user.firstname = firstname
	user.lastname = lastname
	user.email = email
	user.password = password
	user.password_confirmation = password
	user.role_id = role_id
	user.save!
end
