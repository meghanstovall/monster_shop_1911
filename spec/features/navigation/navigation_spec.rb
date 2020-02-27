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
    expect(page).to_not have_link("Register")
  end

  it "shows different things in the navbar for merchants" do
    merchant_1 = User.create!(
      name: "Aladdin",
      street_address: "456 Colorado Street",
      city: "Phoenix",
      state: "CA",
      zip: 98765,
      email: "aladdin@gamil.com",
      password: "drowssap",
      role: 2)

    visit '/login'

    fill_in :email, with: "aladdin@gamil.com"
    fill_in :password, with: "drowssap"

    click_button "Log In"

    expect(page).to have_link("Merchant Dashboard")
    expect(page).to have_link("Logout")
    expect(page).to_not have_link("Login")
    expect(page).to_not have_link("Register")
  end

  it "shows different things in the navbar for admin" do
    admin_1 = User.create!(
      name: "Jaffar",
      street_address: "789 Palace Street",
      city: "Detroit",
      state: "AZ",
      zip: 98345,
      email: "jaffar@gamil.com",
      password: "geniessuck",
      role: 3)

    visit '/login'

    fill_in :email, with: "jaffar@gamil.com"
    fill_in :password, with: "geniessuck"

    click_button "Log In"

    expect(page).to have_link("Admin Dashboard")
    expect(page).to have_link("All Users")
    expect(page).to have_link("Logout")
    expect(page).to_not have_link("Login")
    expect(page).to_not have_link("Register")
    expect(page).to_not have_link("Cart")
  end

  describe "When I try to access any path that begins with /merchant, /admin, /profile" do
    it "I see a 404 error for /merchant" do
      visit '/merchant/dashboard'
      expect(page).to have_content("The page you were looking for doesn't exist (404)")
    end

    it "I see a 404 error for /admin" do
      visit '/admin/dashboard'
      expect(page).to have_content("The page you were looking for doesn't exist (404)")
    end

    it "I see a 404 error for /profile" do
      visit '/profile'
      expect(page).to have_content("The page you were looking for doesn't exist (404)")
    end
  end

  it "default user cannot se admin or merchant dashboards" do
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

    visit '/merchant/dashboard'
    expect(page).to have_content("The page you were looking for doesn't exist (404)")

    visit '/admin/dashboard'
    expect(page).to have_content("The page you were looking for doesn't exist (404)")
  end

  it "merchant cannot see admin dashboard" do
    merchant_1 = User.create!(
      name: "Jaffar",
      street_address: "789 Palace Street",
      city: "Detroit",
      state: "AZ",
      zip: 98345,
      email: "jaffar@gamil.com",
      password: "geniessuck",
      role: 2)

    visit '/login'

    fill_in :email, with: "jaffar@gamil.com"
    fill_in :password, with: "geniessuck"

    click_button "Log In"

    visit '/admin/dashboard'
    expect(page).to have_content("The page you were looking for doesn't exist (404)")
  end

  it "restricts what an admin can see" do
    admin_1 = User.create!(
      name: "Jaffar",
      street_address: "789 Palace Street",
      city: "Detroit",
      state: "AZ",
      zip: 98345,
      email: "jaffar@gamil.com",
      password: "geniessuck",
      role: 3)

    visit '/login'

    fill_in :email, with: "jaffar@gamil.com"
    fill_in :password, with: "geniessuck"

    click_button "Log In"

    visit '/merchant/dashboard'
    expect(page).to have_content("The page you were looking for doesn't exist (404)")
    visit '/cart'
    expect(page).to have_content("The page you were looking for doesn't exist (404)")
  end
end
