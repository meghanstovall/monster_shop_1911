require 'rails_helper'

RSpec.describe it "as a visitor" do
  before: :each do
    @regular_user = User.create!(name: "Mike",street_address: "456 Logan St. Denver, CO",
                              city: "denver",state: "CO",zip: "80206",email: "new_email@gmail.com",password: "hamburger1", role: 1)
    @merchant_user = User.create!(name: "Ben",street_address: "891 Penn St. Denver, CO",
                              city: "denver",state: "CO",zip: "80206",email: "new_email@gmail.com",password: "hamburger2", role: 2)
    @admin_user = User.create!(name: "John",street_address: "123 Colfax St. Denver, CO",
                              city: "denver",state: "CO",zip: "80206",email: "new_email@gmail.com",password: "hamburger3", role: 3)
  end
  
  it 'I can visit the login path' do
    it "and login as an regular user" do
      visit '/'
      expect(page).to have_link(login)
      click_on 'login'

      expect(current_path).to eq('/login')
      expect(page).to have_field?("Email")
      expect(page).to have_field?("Password")
      fill_in :email, with: @regular_user.email
      fill_in :password, with: "hamburger1"
      click_button "Log In"

      expect(current_path).to eq("/profile")
      expect(page).to have_content(@regular_user.street_address)
      expect(page).to have_content(@regular_user.state)
      expect(page).to have_content(@regular_user.city)
      expect(page).to have_content(@regular_user.email)
      expect(page).to have_content("#{@regular_user.name} is logged in!")
    end

    it "and login as a merchant user" do
      visit '/'
      expect(page).to have_link(login)
      click_on 'login'

      expect(current_path).to eq('/login')
      expect(page).to have_field?("Email")
      expect(page).to have_field?("Password")
      fill_in :email, with: @merchant_user.email
      fill_in :password, with: "hamburger2"
      click_button "Log In"

      expect(current_path).to eq("/merchant")
      expect(page).to have_content(@merchant_user.street_address)
      expect(page).to have_content(@merchant_user.state)
      expect(page).to have_content(@merchant_user.city)
      expect(page).to have_content(@merchant_user.email)
      expect(page).to have_content("#{@merchant_user.name} is logged in!")
    end

    it "and login as an admin user" do
      visit '/'
      expect(page).to have_link(login)
      click_on 'login'

      expect(current_path).to eq('/login')
      expect(page).to have_field?("Email")
      expect(page).to have_field?("Password")
      fill_in :email, with: @admin_user.email
      fill_in :password, with: "hamburger3"
      click_button "Log In"

      expect(current_path).to eq("/admin")
      expect(page).to have_content(@admin_user.street_address)
      expect(page).to have_content(@admin_user.state)
      expect(page).to have_content(@admin_user.city)
      expect(page).to have_content(@admin_user.email)
      expect(page).to have_content("#{@admin_user.name} is logged in!")
    end

  end
end
