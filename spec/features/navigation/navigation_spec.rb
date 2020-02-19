require 'rails_helper'

RSpec.describe 'Site Navigation' do

  it 'shows this information from the nav bar' do
  visit '/'
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

  it "a default user sees different things in the nav bar than a visitor does" do

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

    expect(page).to have_content("Logged in as Happy Gilmore")
    expect(page).to have_link("My Profile")

    expect(page).to have_link("Logout")
    expect(page).to_not have_link("Login")
  end
end


# User Story 3, User Navigation
#
# As a default user
# I see the same links as a visitor
# Plus the following links
# - a link to my profile page ("/profile")
# - a link to log out ("/logout")
#
# Minus the following links
# - I do not see a link to log in or register
#
# I also see text that says "Logged in as Mike Dao" (or whatever my name is)
