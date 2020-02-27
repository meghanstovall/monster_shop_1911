require "rails_helper"

RSpec.describe 'new user', type: :features do
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

  it "needs all fields filled in to create a new user" do
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
    fill_in :email, with: email
    fill_in :password, with: password
    fill_in :password_confirmation, with: password_confirmation

    click_on 'Create User'
    expect(current_path).to eq("/register")
    expect(page).to have_content("Zip can't be blank")
  end

  it "needs a unique email to register" do
    visit '/'
    click_link 'Register'
    expect(current_path).to eq("/register")

    user_2 = User.create!(
      name: "Peter Webber",
      street_address: "30 Girls Street",
      city: "Los Angeles",
      state: "CA",
      zip: 90036,
      email: "pilotpete@gmail.com",
      password: "password1",
      password_confirmation: "password1")

    name = "Ryan Allen"
    street_address = "45433 fake st."
    city = "Denver"
    state = "Colorado"
    zip = 80234
    email = "pilotpete@gmail.com"
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

    expect(current_path).to eq('/register')
    expect(page).to have_content("Email has already been taken")
    expect(page).not_to have_content(email)
    expect(find_field("name").value).to eq(name)
    expect(find_field("city").value).to eq(city)
  end
end
