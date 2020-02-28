require 'rails_helper'

RSpec.describe "As an Admin user", type: :feature do
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
    @regular_user = User.create(name: "Mike",
                                street_address: "456 Logan St. Denver, CO",
                                city: "denver",
                                state: "CO",
                                zip: "80206",
                                email: "new_email1@gmail.com",
                                password: "hamburger1",
                                role: 1)
    @regular_user2 = User.create(name: "Moe",
                                 street_address: "1356 Lacienaga Ct. Denver, CO",
                                 city: "denver",
                                 state: "CO",
                                 zip: "80305",
                                 email: "new_email2@gmail.com",
                                 password: "hamburger1",
                                 role: 1)
    @merchant_user1 = @mike.users.create(name: "Larry",
                                 street_address: "4764 Downing St",
                                 city: "Bangor",
                                 state: "ME",
                                 zip: "04401",
                                 email: "merch_man@gmail.com",
                                 password: "hamburger1",
                                 role: 2)
    @merchant_user2 = @meg.users.create(name: "Curly",
                                 street_address: "9865 Mexico Ave",
                                 city: "Medina",
                                 state: "MN",
                                 zip: "73622",
                                 email: "merch_man_2@gmail.com",
                                 password: "hamburger2",
                                 role: 2)
    visit '/login'
    fill_in :email, with: @admin_user.email
    fill_in :password, with: @admin_user.password
    click_button "Log In"
    visit "users/#{@regular_user.id}"
  end

  it "shows the users information and not a link to edit their profile" do
    expect(current_path).to eq("/admin/users/#{@regular_user.id}")
    expect(page).to have_content(@regular_user.name)
    expect(page).to have_content(@regular_user.street_address)
    expect(page).to have_content(@regular_user.city)
    expect(page).to have_content(@regular_user.state)
    expect(page).to have_content(@regular_user.zip)
    expect(page).to have_content(@regular_user.email)
    
    expect(page).to_not have_link('Edit Profile')
    expect(page).to_not have_content('hamburger1')
  end
end
