require "rails_helper"

describe 'new user' do
  	it 'I should be able to register as a new user' do

  		visit '/'

  		click_link 'Register'

  		expect(current_path).to eq("/register")

  		name = "Alex Meghan Elom"
  		street_address = "45433 fake st."
  		city = "Denver"
  		state = "Colorado"
  		zip = 80234
  		email = "ame@fake.com"
  		password = "BestFakerEver"
  		password_confirmation = "BestFakerEver"

  		fill_in :name, with: name
  		fill_in :street_address, with: street_address
  		fill_in :city, with: city
  		fill_in :state, with: state
  		fill_in :zip, with: zip
  		fill_in :email, with: email
  		fill_in :password, with: password
  		fill_in :password_confirmation, with: password_confirmation

  		click_on 'Create User'
  		expect(current_path).to eq('/profile')
      expect(page).to have_content("#{name} is now logged in")
    end
  end
