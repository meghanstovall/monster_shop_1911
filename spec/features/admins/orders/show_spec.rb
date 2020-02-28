require "rails_helper"

RSpec.describe "Admin user", type: :feature do
  before :each do
    @admin_user = User.create!(name: "John",
                              street_address: "123 Colfax St. Denver, CO",
                              city: "denver",
                              state: "CO",
                              zip: "80206",
                              email: "new_email3@gmail.com",
                              password: "hamburger3",
                              role: 3)
    @regular_user = User.create(name: "Mike",street_address: "456 Logan St. Denver, CO",
                              city: "denver",state: "CO",zip: "80206",email: "new_email1@gmail.com",password: "hamburger1", role: 1)
    @mike = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
    @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)

    @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
    @paper = @mike.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 3)

    @user_order = @regular_user.orders.create(name: @regular_user.name, address: @regular_user.street_address, city: @regular_user.city, state: @regular_user.state, zip: @regular_user.zip)
    @tire_order = ItemOrder.create!(item: @tire, order: @user_order, price: @tire.price, quantity: 7)
    @paper_order = ItemOrder.create!(item: @paper, order: @user_order, price: @paper.price, quantity: 10)

    visit '/login'
    fill_in :email, with: @admin_user.email
    fill_in :password, with: @admin_user.password
    click_button "Log In"
  end

  it "can go to orders show page" do
    visit "/admin/merchants/#{@meg.id}/orders/#{@user_order.id}"

    expect(page).to have_content(@user_order.name)
    expect(page).to have_content(@user_order.address)
    expect(page).to have_content(@user_order.city)
    expect(page).to have_content(@user_order.state)
    expect(page).to have_content(@user_order.zip)

    expect(page).to have_content("Item: #{@tire.name}")
    expect(page).to have_content("Price: #{@tire.price}")
    expect(page).to have_content("Quantity of Items in Order: #{@tire_order.quantity}")

    expect(page).to_not have_content(@paper.name)
    expect(page).to_not have_content("Quantity of Items in Order: #{@paper_order.quantity}")

    click_link "#{@tire.name}"
    expect(current_path).to eq("/items/#{@tire.id}")
  end

  it "can fulfill their items in te order" do
    visit "/admin/merchants/#{@meg.id}/orders/#{@user_order.id}"

    within "#item-#{@tire.id}" do
      click_link "Fulfill Item"
    end
    
    expect(current_path).to eq("/admin/merchants/#{@meg.id}/orders/#{@user_order.id}")
    expect(page).to have_content("Status: fulfilled")
    expect(page).to have_content("You have fulfilled the order for #{@tire.name}")
  end

  it "cant see fulfill button if quantity is greater than inventory" do
    visit "/admin/merchants/#{@mike.id}/orders/#{@user_order.id}"

    within "#item-#{@paper.id}" do
      expect(page).to_not have_link("Fulfill Item")
      expect(page).to have_content("Cannot fulfill this item: Not enough inventory")
    end
  end
end
