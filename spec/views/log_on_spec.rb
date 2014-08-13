require 'spec_helper'
require 'capybara/rspec'

describe "the login page" do

	before(:all) do
	    visit /users/sign_in
  	end


	it "gives an error message if an email is not entered" do


		expect(page).to have_content("error message")
	end

	it "gives an error message if a password is not entered" do

		expect(page).to have_content("error message")
	end

end