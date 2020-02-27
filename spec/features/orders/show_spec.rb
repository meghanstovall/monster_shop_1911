require 'rails_helper'

RSpec.describe "orders index page", type: :feature do
  before(:each) do
    @mike = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
    @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
    @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
    @paper = @mike.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 3)

    @regular_user = User.create(name: "Mike",street_address: "456 Logan St. Denver, CO",
                              city: "denver",state: "CO",zip: "80206",email: "new_email1@gmail.com",password: "hamburger1", role: 1)

    @user_order = @regular_user.orders.create(name: @regular_user.name, address: @regular_user.street_address, city: @regular_user.city, state: @regular_user.state, zip: @regular_user.zip)
    @tire_order = ItemOrder.create!(item: @tire, order: @user_order, price: @tire.price, quantity: 7)
    @paper_order = ItemOrder.create!(item: @paper, order: @user_order, price: @paper.price, quantity: 4)

    visit '/'
    click_link 'Login'
    fill_in :email, with: @regular_user.email
    fill_in :password, with: 'hamburger1'
    click_button 'Log In'

    visit '/profile/orders'
  end

  scenario "user profile orders shows link to order show page" do
    click_link @user_order.id
    expect(current_path).to eq("/profile/orders/#{@user_order.id}")
  end

  scenario "profile order show page has all order information" do
    visit "/profile/orders/#{@user_order.id}"

    expect(page).to have_content("Order ID: #{@user_order.id}")
    expect(page).to have_content("Order Made On: #{@user_order.created_at}")
    expect(page).to have_content("Order Last Updated On: #{@user_order.updated_at}")
    expect(page).to have_content("Order Status: #{@user_order.status}")
    expect(page).to have_content("Total Item Quantity: 11")
    expect(page).to have_content("Total: $780.00")

    within "#item-#{@tire.id}" do
      expect(page).to have_content(@tire.name)
      expect(page).to have_css("img[src='#{@tire.image}']")
      expect(page).to have_content(@tire_order.quantity)
      expect(page).to have_content(@tire.price)
      expect(page).to have_content(@tire_order.subtotal)
    end

    within "#item-#{@paper.id}" do
      expect(page).to have_content(@paper.name)
      expect(page).to have_css("img[src='#{@paper.image}']")
      expect(page).to have_content(@paper_order.quantity)
      expect(page).to have_content(@paper.price)
      expect(page).to have_content(@paper_order.subtotal)
    end
  end

  scenario "can cancel an order" do
    visit '/profile/orders'

    visit "/profile/orders/#{@user_order.id}"
    click_button 'Cancel'

    expect(current_path).to eq('/profile/orders')
    expect(page).to have_content('Order has been cancelled.')

    within "#order-#{@user_order.id}" do
      expect(page).to have_content('cancelled')
    end
  end

  scenario "all merchants fulfill items on an order, status changes" do
    visit '/profile'
    @merchant_user = User.create!(name: "Ben",street_address: "891 Penn St. Denver, CO",
                              city: "denver",state: "CO",zip: "80206",email: "new_email2@gmail.com",password: "hamburger2", role: 2)

    click_link "Logout"
    visit '/'
    click_link "Login"
    expect(current_path).to eq('/login')

    fill_in :email, with: @merchant_user.email
    fill_in :password, with: "hamburger2"
    click_button "Log In"
    expect(current_path).to eq("/merchant/dashboard")

    merchant_order = @merchant_user.orders.create(name: @merchant_user.name, address: @merchant_user.street_address, city: @merchant_user.city, state: @merchant_user.state, zip: @merchant_user.zip)

    ItemOrder.create!(item: @tire, order: merchant_order, price: @tire.price, quantity: 2, status:1)
    ItemOrder.create!(item: @paper, order: merchant_order, price: @paper.price, quantity: 3)

    expect(merchant_order.status).to eq("pending")
    merchant_order.fulfill
    expect(merchant_order.status).to eq("packaged")
  end
end
