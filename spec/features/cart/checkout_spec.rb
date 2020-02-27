require 'rails_helper'

RSpec.describe 'Cart show' do
  describe 'When I have added items to my cart' do
    before(:each) do
      @mike = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)

      @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      @paper = @mike.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 3)
      @pencil = @mike.items.create(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)
      visit "/items/#{@paper.id}"
      click_on "Add To Cart"
      visit "/items/#{@tire.id}"
      click_on "Add To Cart"
      visit "/items/#{@pencil.id}"
      click_on "Add To Cart"
      @items_in_cart = [@paper,@tire,@pencil]
    end

    it 'Theres a link to checkout' do
      visit "/cart"
      expect(page).to have_link("Checkout")

      click_on "Checkout"
      expect(current_path).to eq("/orders/new")
    end

    it "creates order after checking out and sees flash message" do
      tim = User.create!(name: 'Tim',
                      street_address: '123 Turing St',
                      city: 'Denver',
                      state: 'CO',
                      zip: '80020',
                      email: 'tim@gmail.com',
                      password: 'password1',
                      password_confirmation: "password1",
                      role: 1)

      click_link "Login"

      fill_in :email, with: tim.email
      fill_in :password, with: tim.password
      click_button "Log In"

      click_link "Cart: 3"
      click_link "Checkout"

      fill_in :name, with: tim.name
      fill_in :address, with: tim.street_address
      fill_in :city, with: tim.city
      fill_in :state, with: tim.state
      fill_in :zip, with: tim.zip
      click_button "Create Order"

      new_order = Order.last

      expect(tim.orders).to eq([new_order])
      expect(new_order.status).to eq('pending')

      expect(current_path).to eq("/profile/orders")
      expect(page).to have_content("Your order has been placed!")
      expect(page).to have_link("Cart: 0")
    end

    it "cant see checkout button when an item is inactive" do
      @lead = @mike.items.create(name: "Pencil Lead", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 50)

      visit "/items/#{@lead.id}"
      click_on "Add To Cart"

      @lead.update(active?: false)

      visit "/cart"
      expect(page).to_not have_link("Checkout")
      expect(page).to have_content("Can't checkout with inactive items")
    end
  end

  describe 'When I havent added items to my cart' do
    it 'There is not a link to checkout' do
      visit "/cart"

      expect(page).to_not have_link("Checkout")
    end
  end
end
