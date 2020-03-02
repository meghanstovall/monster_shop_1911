require "rails_helper"

RSpec.describe "as a merchant", type: :feature do
  before :each do
    @bike_shop = Merchant.create!(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Richmond', state: 'VA', zip: 23137)
    @dog_shop = Merchant.create(name: "Meg's Dog Shop", address: '123 Dog Rd.', city: 'Denver', state: 'CO', zip: 80203)

    @user = User.create!(name: "Sally", street_address: "111 Drive", city: "Broomfield", state: "CO", zip: 80020, email: "sally@gmail.com", password: "fries1", role: 1)
    @merchant_user = @bike_shop.users.create!(name: "Ben", street_address: "123 Turing St", city: "Denver", state: "CO", zip: 80020, email: "ben@gmail.com", password: "password", role: 2)

    @bone = @dog_shop.items.create(name: "Bone", description: "They'll love it", price: 8, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 100)
    @chain = @bike_shop.items.create(name: "Chain", description: "It'll never break!", price: 40, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 100)

    @order_1 = @user.orders.create!(name: "Sally", address: "111 Drive", city: "Broomfield", state: "CO", zip: 80020)
    @order_1.item_orders.create!(item: @bone, price: @bone.price, quantity: 10)
    @order_1.item_orders.create!(item: @chain, price: @chain.price, quantity: 10)

    @order_2 = @user.orders.create!(name: "Sally", address: "111 Drive", city: "Broomfield", state: "CO", zip: 80020)
    @order_2.item_orders.create!(item: @chain, price: @chain.price, quantity: 10)

    @order_3 = @user.orders.create!(name: "Sally", address: "111 Drive", city: "Broomfield", state: "CO", zip: 80020)

    @discount_1 = @bike_shop.discounts.create!(name: "5% Discount", percent_off: 5, min_quantity: 10)
    @discount_2 = @bike_shop.discounts.create!(name: "10% Discount", percent_off: 10, min_quantity: 20)
    @discount_3 = @dog_shop.discounts.create!(name: "15% Discount", percent_off: 15, min_quantity: 30)

    visit '/'
    click_link 'Login'
    expect(current_path).to eq('/login')

    fill_in :email, with: @merchant_user.email
    fill_in :password, with: 'password'
    click_button 'Log In'
    expect(current_path).to eq("/merchant/dashboard")

    click_link "Manage Discounts"
  end

  it "can edit a discount" do
    within "#discount-#{@discount_2.id}" do
      click_link "#{@discount_2.id}"
      expect(current_path).to eq("/merchant/discounts/#{@discount_2.id}")
    end
    click_link "Edit"

    fill_in :name, with: "20% Discount"
    fill_in :percent_off, with: 20
    fill_in :min_quantity, with: 50

    click_button "Update"
    expect(current_path).to eq("/merchant/discounts")
    expect(page).to have_content("Discount has been updated!")
    expect(page).to have_content("Name: 20% Discount")
    expect(page).to have_content("Percent Off: 20%")
    expect(page).to have_content("Minimum Quantity: 50")
  end

  it "can't leave a field blank when editing" do
    within "#discount-#{@discount_2.id}" do
      click_link "#{@discount_2.id}"
      expect(current_path).to eq("/merchant/discounts/#{@discount_2.id}")
    end
    click_link "Edit"

    fill_in :name, with: ""
    fill_in :percent_off, with: 20
    fill_in :min_quantity, with: 50

    click_button "Update"
    expect(current_path).to eq("/merchant/discounts/#{@discount_2.id}")
    expect(page).to have_content("Name can't be blank")
  end
end
