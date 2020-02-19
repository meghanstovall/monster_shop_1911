require 'rails_helper'

RSpec.describe 'Site Navigation' do
  before :each do

    visit '/'

		click_link 'Register'

		expect(current_path).to eq("/register")

		name = "Happy Gilmore"
		street_address = "45433 Fake st."
		city = "Denver"
		state = "Colorado"
		zip = 80234
		email = "strangerthings@gmail.com"
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
  end

  it 'shows this information from the nav bar' do
      within('#top-nav') do
        expect(page).to have_link("Home")
        expect(page).to have_link("All Merchants")
        expect(page).to have_link("All Items")
        expect(page).to have_link("Cart")
        expect(page).to have_link("Login")
        expect(page).to have_link("Register as New User")
        expect(page).to have_content("Cart: 0")
    end
  end
end

# User Story 2, Visitor Navigation
#
# As a visitor
# I see a navigation bar
# This navigation bar includes links for the following:
# - a link to return to the welcome / home page of the application ("/")
# - a link to browse all items for sale ("/items")
# - a link to see all merchants ("/merchants")
# - a link to my shopping cart ("/cart")
# - a link to log in ("/login")
# - a link to the user registration page ("/register")
#
# Next to the shopping cart link I see a count of the items in my cart
