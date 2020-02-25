require 'rails_helper'

RSpec.describe "As an Admin user" do
  before :each do
    @admin_user = User.create!(name: "John",
                              street_address: "123 Colfax St. Denver, CO",
                              city: "denver",
                              state: "CO",
                              zip: "80206",
                              email: "new_email3@gmail.com",
                              password: "hamburger3",
                              role: 3)

    @mike = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
    @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)


    visit '/login'
    fill_in :email, with: @admin_user.email
    fill_in :password, with: @admin_user.password
    click_button "Log In"

    visit '/admin/merchants'
  end

  it "can see every merchant and the cities they operate in and if they are disbaled or not" do

    within"#merchant-#{@mike.id}" do
      expect(page).to have_link(@mike.name)
      expect(page).to have_content(@mike.city)
      expect(page).to have_content(@mike.state)
      expect(page).to have_content("Disable")
    end

    within"#merchant-#{@meg.id}" do
      expect(page).to have_link(@meg.name)
      expect(page).to have_content(@meg.city)
      expect(page).to have_content(@meg.state)
      expect(page).to have_content("Disable")
    end
  end
end
