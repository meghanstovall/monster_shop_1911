require 'rails_helper'

RSpec.describe "different users login" do
  before(:each) do
    User.destroy_all

    @visitor_user = User.create!(name: "Damon",street_address: "2417 E. Curtis St. Denver, CO",
                              city: "denver",state: "CO",zip: "80206",email: "new_email0@gmail.com",password: "hamburger0", role: 0)
    @regular_user = User.create!(name: "Mike",street_address: "456 Logan St. Denver, CO",
                              city: "denver",state: "CO",zip: "80206",email: "new_email1@gmail.com",password: "hamburger1", role: 1)
    @merchant_user = User.create!(name: "Ben",street_address: "891 Penn St. Denver, CO",
                              city: "denver",state: "CO",zip: "80206",email: "new_email2@gmail.com",password: "hamburger2", role: 2)
    @admin_user = User.create!(name: "John",street_address: "123 Colfax St. Denver, CO",
                              city: "denver",state: "CO",zip: "80206",email: "new_email3@gmail.com",password: "hamburger3", role: 3)


    @dog_shop = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)
    @pull_toy = @dog_shop.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)

    visit '/'
  end

  it 'can log out as a regular user' do
    click_link 'Login'
    expect(current_path).to eq('/login')

    fill_in :email, with: @regular_user.email
    fill_in :password, with: 'hamburger1'
    click_button 'Log In'

    click_link "All Items"
    click_link "Pull Toy"
    click_button "Add To Cart"
    expect(page).to have_content("Cart: 1")

    click_link "Logout"
    expect(current_path).to eq('/')
    expect(page).to have_content("You have successfully logged out.")
    expect(page).to have_content("Cart: 0")
  end

  it 'can log out as a merchant' do
    click_link 'Login'
    expect(current_path).to eq('/login')

    fill_in :email, with: @merchant_user.email
    fill_in :password, with: 'hamburger2'
    click_button 'Log In'

    click_link "All Items"
    click_link "Pull Toy"
    click_button "Add To Cart"
    expect(page).to have_content("Cart: 1")

    click_link "Logout"
    expect(current_path).to eq('/')
    expect(page).to have_content("You have successfully logged out.")
    expect(page).to have_content("Cart: 0")
  end

  it 'can log out as an admin' do
    click_link 'Login'
    expect(current_path).to eq('/login')

    fill_in :email, with: @admin_user.email
    fill_in :password, with: 'hamburger3'
    click_button 'Log In'

    click_link "Logout"
    expect(current_path).to eq('/')
    expect(page).to have_content("You have successfully logged out.")
  end
end
