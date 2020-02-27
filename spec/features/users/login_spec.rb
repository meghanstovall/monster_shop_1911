require 'rails_helper'

RSpec.describe "different users login" do
  before(:each) do
    @visitor_user = User.create!(name: "Damon",street_address: "2417 E. Curtis St. Denver, CO",
                              city: "denver",state: "CO",zip: "80206",email: "new_email0@gmail.com",password: "hamburger0", role: 0)
    @regular_user = User.create!(name: "Mike",street_address: "456 Logan St. Denver, CO",
                              city: "denver",state: "CO",zip: "80206",email: "new_email1@gmail.com",password: "hamburger1", role: 1)
    @merchant_user = User.create!(name: "Ben",street_address: "891 Penn St. Denver, CO",
                              city: "denver",state: "CO",zip: "80206",email: "new_email2@gmail.com",password: "hamburger2", role: 2)
    @admin_user = User.create!(name: "John",street_address: "123 Colfax St. Denver, CO",
                              city: "denver",state: "CO",zip: "80206",email: "new_email3@gmail.com",password: "hamburger3", role: 3)
    visit '/'
  end

  describe 'user visits login path' do
    it 'logs in as a regular user' do
      click_link 'Login'
      expect(current_path).to eq('/login')

      fill_in :email, with: @regular_user.email
      fill_in :password, with: 'hamburger1'
      click_button 'Log In'

      expect(current_path).to eq('/profile')
      expect(page).to have_content(@regular_user.name)
      expect(page).to have_content(@regular_user.street_address)
      expect(page).to have_content(@regular_user.city)
      expect(page).to have_content(@regular_user.state)
      expect(page).to have_content(@regular_user.zip)
      expect(page).to have_content(@regular_user.email)
      expect(page).to have_content("#{@regular_user.name} is logged in.")
    end
  end

  it 'logs in as a merchant user' do
    click_link 'Login'
    expect(current_path).to eq('/login')

    fill_in :email, with: @merchant_user.email
    fill_in :password, with: 'hamburger2'
    click_button 'Log In'

    expect(current_path).to eq('/merchant/dashboard')
  end

  it 'logs in as an admin user' do
    click_link 'Login'
    expect(current_path).to eq('/login')

    fill_in :email, with: @admin_user.email
    fill_in :password, with: 'hamburger3'
    click_button 'Log In'

    expect(current_path).to eq('/admin/dashboard')
  end

  it "cannot log in with incorrect credentials" do
    visit '/login'
    fill_in :email, with: @regular_user.email
    fill_in :password, with: "bonsai"
    click_button "Log In"
    expect(current_path).to eq("/login")
    expect(page).to have_content("Login Failed; Your Credentials were Incorrect")
  end

  it "cannot access /login as regular user if regular user is already logged in" do
    click_link 'Login'
    expect(current_path).to eq('/login')
    fill_in :email, with: @regular_user.email
    fill_in :password, with: 'hamburger1'
    click_button 'Log In'
    expect(current_path).to eq('/profile')

    visit '/login'
    expect(current_path).to eq('/profile')
    expect(page).to have_content("Already logged in as #{@regular_user.name}")
  end

  it "cannot access /login as  merchant if  merchant_user is already logged in" do
    click_link 'Login'
    expect(current_path).to eq('/login')

    fill_in :email, with: @merchant_user.email
    fill_in :password, with: 'hamburger2'
    click_button 'Log In'
    expect(current_path).to eq('/merchant/dashboard')

    visit '/login'
    expect(current_path).to eq('/merchant/dashboard')
    expect(page).to have_content("Already logged in as #{@merchant_user.name}")
  end

  it "cannot access /login as admi user if admin user is already logged in" do
    click_link 'Login'
    expect(current_path).to eq('/login')

    fill_in :email, with: @admin_user.email
    fill_in :password, with: 'hamburger3'
    click_button 'Log In'
    expect(current_path).to eq('/admin/dashboard')
    
    visit '/login'
    expect(current_path).to eq('/admin/dashboard')
    expect(page).to have_content("Already logged in as #{@admin_user.name}")
  end
end
