require 'rails_helper'

RSpec.describe "admin sees all orders", type: :feature do
  before(:each) do
    @admin_user = User.create!(name: "John",street_address: "123 Colfax St. Denver, CO",
                              city: "denver",state: "CO",zip: "80206",email: "new_email3@gmail.com",password: "hamburger3", role: 3)

    @regular_user = User.create(name: "Mike",street_address: "456 Logan St. Denver, CO",
                                                        city: "denver",state: "CO",zip: "80206",email: "new_email1@gmail.com",password: "hamburger1", role: 1)
    @regular_user2 = User.create(name: "Moe",street_address: "1356 Lacienaga Ct. Denver, CO",
                                                        city: "denver",state: "CO",zip: "80305",email: "new_email2@gmail.com",password: "hamburger1", role: 1)

    @order_1 = @regular_user.orders.create(name: @regular_user.name, address: @regular_user.street_address, city: @regular_user.city, state: @regular_user.state, zip: @regular_user.zip, status: 0)
    @order_2 = @regular_user.orders.create(name: @regular_user.name, address: @regular_user.street_address, city: @regular_user.city, state: @regular_user.state, zip: @regular_user.zip, status: 1)
    @order_3 = @regular_user.orders.create(name: @regular_user.name, address: @regular_user.street_address, city: @regular_user.city, state: @regular_user.state, zip: @regular_user.zip, status: 2)
    @order_4 = @regular_user2.orders.create(name: @regular_user2.name, address: @regular_user2.street_address, city: @regular_user2.city, state: @regular_user2.state, zip: @regular_user2.zip, status: 2)
    @order_5 = @regular_user2.orders.create(name: @regular_user2.name, address: @regular_user2.street_address, city: @regular_user2.city, state: @regular_user2.state, zip: @regular_user2.zip, status: 3)
    @order_6 = @regular_user2.orders.create(name: @regular_user2.name, address: @regular_user2.street_address, city: @regular_user2.city, state: @regular_user2.state, zip: @regular_user2.zip, status: 0)

    @mike = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
    @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)

    @item1 = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
    @item2 = @mike.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 3)
    @item3 = @mike.items.create(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)

    @item_order1 = ItemOrder.create!(item: @item1, order: @order_1, price: @item1.price, quantity: 7)
    @item_order2 = ItemOrder.create!(item: @item2, order: @order_2, price: @item2.price, quantity: 4)
    @item_order3 = ItemOrder.create!(item: @item3, order: @order_3, price: @item3.price, quantity: 10)
    @item_order4 = ItemOrder.create!(item: @item1, order: @order_4, price: @item1.price, quantity: 2)
    @item_order5 = ItemOrder.create!(item: @item2, order: @order_5, price: @item2.price, quantity: 15)
    @item_order6 = ItemOrder.create!(item: @item3, order: @order_6, price: @item3.price, quantity: 40)

    visit '/login'
    fill_in :email, with: @admin_user.email
    fill_in :password, with: @admin_user.password
    click_button "Log In"
    expect(current_path).to eq("/admin/dashboard")
  end

  scenario "admin sees all orders with their information and they are sorted" do
    within "#packaged" do
      within "#packaged-order#{@order_3.id}" do
        expect(page).to have_link(@order_3.name)
        expect(page).to have_content(@order_3.id)
        expect(page).to have_content(@order_3.created_at)
      end

      within "#packaged-order#{@order_4.id}" do
        expect(page).to have_link(@order_4.name)
        expect(page).to have_content(@order_4.id)
        expect(page).to have_content(@order_4.created_at)
      end
    end

    within "#pending" do
      within "#pending-order#{@order_1.id}" do
        expect(page).to have_link(@order_1.name)
        expect(page).to have_content(@order_1.id)
        expect(page).to have_content(@order_1.created_at)
      end

      within "#pending-order#{@order_6.id}" do
        expect(page).to have_link(@order_6.name)
        expect(page).to have_content(@order_6.id)
        expect(page).to have_content(@order_6.created_at)
      end
    end

    within "#shipped" do
      within "#shipped-order#{@order_5.id}" do
        expect(page).to have_link(@order_5.name)
        expect(page).to have_content(@order_5.id)
        expect(page).to have_content(@order_5.created_at)
      end
    end

    within "#cancelled" do
      within "#cancelled-order#{@order_2.id}" do
        expect(page).to have_link(@order_2.name)
        expect(page).to have_content(@order_2.id)
        expect(page).to have_content(@order_2.created_at)

        click_link(@order_2.name)
        expect(current_path).to eq("/admin/profile/#{@regular_user.id}")
      end
    end
  end

  scenario "admin can ship an order" do
    within "#packaged" do
      within "#packaged-order#{@order_3.id}" do
        expect(@order_3.status).to eq('packaged')
        expect(page).to have_button('Ship this Order')
        click_button('Ship this Order')
        expect(current_path).to eq("/admin/dashboard")
      end

      within "#packaged-order#{@order_4.id}" do
        expect(@order_4.status).to eq('packaged')
        expect(page).to have_button('Ship this Order')
        click_button('Ship this Order')
        expect(current_path).to eq("/admin/dashboard")
      end
    end

    within "#shipped" do
      expect(page).to have_link(@order_3.name)
      expect(page).to have_link(@order_4.name)
    end

    visit "/profile/orders/#{@order_3.id}"
    expect(page).to_not have_button("Cancel")

    visit "/profile/orders/#{@order_4.id}"
    expect(page).to_not have_button("Cancel")
  end
end
