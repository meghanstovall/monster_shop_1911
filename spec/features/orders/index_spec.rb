require 'rails_helper'

RSpec.describe "orders index page" do
  before(:each) do
    @mike = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
    @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
    @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
    @paper = @mike.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 3)
    @pencil = @mike.items.create(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)

    @regular_user = User.create(name: "Mike",street_address: "456 Logan St. Denver, CO",
                              city: "denver",state: "CO",zip: "80206",email: "new_email1@gmail.com",password: "hamburger1", role: 1)
    visit '/'
    click_link 'Login'
    fill_in :email, with: @regular_user.email
    fill_in :password, with: 'hamburger1'
    click_button 'Log In'


    visit "/items/#{@paper.id}"
    click_on "Add To Cart"
    visit "/items/#{@paper.id}"
    click_on "Add To Cart"
    visit "/items/#{@tire.id}"
    click_on "Add To Cart"
    visit "/items/#{@pencil.id}"
    click_on "Add To Cart"
    visit "/cart"
    click_on "Checkout"

    fill_in :name, with: @regular_user.name
    fill_in :address, with: @regular_user.street_address
    fill_in :city, with: @regular_user.city
    fill_in :state, with: @regular_user.state
    fill_in :zip, with: @regular_user.zip
    click_button "Create Order"
    @user_order = Order.last
  end

  scenario "user profile displays orders link" do
    visit '/profile'

    expect(page).to have_link('My Orders')
    click_link('My Orders')
    expect(current_path).to eq('/profile/orders')
  end

  scenario "user profile orders page displays all orders" do
    visit '/profile'
    click_link('My Orders')
    expect(current_path).to eq('/profile/orders')

    within "#order-#{@user_order.id}" do
      # save_and_open_page
      expect(page).to have_link(@user_order.id)
      expect(page).to have_content("Order ID: #{@user_order.id}")
      expect(page).to have_content(@user_order.created_at)
      expect(page).to have_content(@user_order.updated_at)
      expect(page).to have_content(@user_order.status)
      expect(page).to have_content("Total Item Quantity: 4")
      expect(page).to have_content("Grand Total of All Items: $142.00")
    end

  end

  scenario "user profile orders show page displays order info" do

  end
end
