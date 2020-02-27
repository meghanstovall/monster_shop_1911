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
  end

  it "can see users information from as an admin from the users link in the nav bar" do
    click_link "All Users"
    expect(current_path).to eq("/admin/users")

    within"#user-#{@regular_user.id}" do
      expect(page).to have_link(@regular_user.name)
      expect(page).to have_content(@regular_user.created_at.strftime("%Y-%m-%d"))
      expect(page).to have_content("Role: default")
    end

    within"#user-#{@regular_user2.id}" do
      expect(page).to have_link(@regular_user2.name)
      expect(page).to have_content(@regular_user2.created_at.strftime("%Y-%m-%d"))
      expect(page).to have_content("Role: default")
    end

    within"#user-#{@merchant_user1.id}" do
      expect(page).to have_link(@merchant_user1.name)
      expect(page).to have_content(@merchant_user1.created_at.strftime("%Y-%m-%d"))
      expect(page).to have_content("Role: merchant")
    end

    within"#user-#{@merchant_user2.id}" do
      expect(page).to have_link(@merchant_user2.name)
      expect(page).to have_content(@merchant_user2.created_at.strftime("%Y-%m-%d"))
      expect(page).to have_content("Role: merchant")
    end
  end

  it "cannot see all users link if not admin" do
    click_link "Logout"
    visit '/login'

    fill_in :email, with: @merchant_user1.email
    fill_in :password, with: @merchant_user1.password

    click_button "Log In"

    within"#top-nav" do
      expect(page).to_not have_link("All Users")
    end
  end
end
