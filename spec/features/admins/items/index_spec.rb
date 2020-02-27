require 'rails_helper'

RSpec.describe 'Admin User', type: :feature do
  before(:each) do
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

    @item1 = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
    @item2 = @mike.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 3)
    @item3 = @mike.items.create(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)


    visit '/login'
    fill_in :email, with: @admin_user.email
    fill_in :password, with: @admin_user.password
    click_button "Log In"

    visit "/admin/merchants/#{@mike.id}/items"
  end

  scenario 'see all items for that merchant' do
    within "#item-#{@item2.id}" do
      expect(page).to have_content(@item2.name)
      expect(page).to have_content(@item2.description)
      expect(page).to have_content("Price: $20.00")
      expect(page).to have_css("img[src*='#{@item2.image}']")
      expect(page).to have_content("Active")
      expect(page).to have_content("Inventory: 3")
    end

    within "#item-#{@item3.id}" do
      expect(page).to have_content(@item3.name)
      expect(page).to have_content(@item3.description)
      expect(page).to have_content("Price: $2")
      expect(page).to have_css("img[src*='#{@item3.image}']")
      expect(page).to have_content("Active")
      expect(page).to have_content("Inventory: 100")
    end

    expect(page).not_to have_css("#item-#{@item1.id}")
  end

  scenario "can activate and deactivate items" do
    within "#item-#{@item2.id}" do
      expect(page).to have_link("Deactivate #{@item2.name}")
      click_link("Deactivate #{@item2.name}")
      expect(page).to have_link("Activate #{@item2.name}")
      click_link("Activate #{@item2.name}")
      expect(page).to have_link("Deactivate #{@item2.name}")
    end

    expect(page).to have_content("#{@item2.name} is now available for sale.")

    within "#item-#{@item3.id}" do
      expect(page).to have_link("Deactivate #{@item3.name}")
      click_link("Deactivate #{@item3.name}")
      expect(page).to have_link("Activate #{@item3.name}")
    end

    expect(page).to have_content("#{@item3.name} is no longer for sale.")
  end

  scenario "can delete items" do
    within "#item-#{@item2.id}" do
      expect(page).to have_link("Delete #{@item2.name}")
      click_link("Delete #{@item2.name}")
    end

    within "#item-#{@item3.id}" do
      expect(page).to have_link("Delete #{@item3.name}")
    end

    expect(current_path).to eq("/admin/merchants/#{@mike.id}/items")
    expect(page).to have_content("#{@item2.name} is now deleted.")
    expect(page).to_not have_css("#item-#{@item2.id}")
  end

  scenario "can add an item" do
    expect(page).to have_link("Add New Item")
    click_link('Add New Item')
    expect(current_path).to eq("/admin/merchants/#{@mike.id}/items/new")

    fill_in :name, with: @item1.name
    fill_in :price, with: @item1.price
    fill_in :description, with: @item1.description
    fill_in :image, with: @item1.image
    fill_in :inventory, with: @item1.inventory

    click_button "Add Item"
    @added_item = Item.last

    expect(current_path).to eq("/admin/merchants/#{@mike.id}/items")
    expect(page).to have_content("#{@added_item.name} is saved.")
    within "#item-#{@added_item.id}" do
      expect(page).to have_content(@added_item.name)
      expect(page).to have_content(@added_item.description)
      expect(page).to have_content("Price: $100.00")
      expect(page).to have_css("img[src*='#{@added_item.image}']")
      expect(page).to have_content("Active")
      expect(page).to have_content("Inventory: 12")
    end
  end

  scenario "adds default image" do
    expect(page).to have_link("Add New Item")
    click_link('Add New Item')
    expect(current_path).to eq("/admin/merchants/#{@mike.id}/items/new")

    fill_in :name, with: @item1.name
    fill_in :price, with: @item1.price
    fill_in :description, with: @item1.description
    fill_in :image, with: nil
    fill_in :inventory, with: @item1.inventory

    click_button "Add Item"
    @added_item = Item.last
    within "#item-#{@added_item.id}" do
      expect(page).to have_css("img[src*='https://i.picsum.photos/id/866/200/300.jpg']")
    end
  end

  scenario "cannot add item with bad/missing details" do
    click_link('Add New Item')
    expect(current_path).to eq("/admin/merchants/#{@mike.id}/items/new")

    fill_in :name, with: ""
    fill_in :price, with: @item1.price
    fill_in :description, with: @item1.description
    fill_in :image, with: nil
    fill_in :inventory, with: ""

    click_button "Add Item"

    expect(page).to have_content("Name can't be blank, Inventory can't be blank, and Inventory is not a number")
    expect(page).to have_button("Add Item")
  end

  scenario "can edit item and see default image" do
    within "#item-#{@item2.id}" do
      click_link("Edit #{@item2.name}")
    end

    expect(current_path).to eq("/admin/merchants/#{@mike.id}/items/#{@item2.id}/edit")
    fill_in :name, with: "Hornswoggle"
    fill_in :price, with: @item1.price
    fill_in :description, with: @item1.description
    fill_in :image, with: nil
    fill_in :inventory, with: @item1.inventory

    click_button('Update Item')

    expect(page).to have_content('Hornswoggle is updated.')

    within "#item-#{@item2.id}" do
      expect(page).to have_content("Hornswoggle")
      expect(page).to have_content(@item1.price)
      expect(page).to have_content(@item1.description)
      expect(page).to have_css("img[src*='https://i.picsum.photos/id/866/200/300.jpg']")
      expect(page).to have_content("Active")
      expect(page).to have_content(@item1.inventory)
    end
  end

  scenario "cannot edit item with faulty or missing information" do
    within "#item-#{@item2.id}" do
      click_link("Edit #{@item2.name}")
    end

    expect(current_path).to eq("/admin/merchants/#{@mike.id}/items/#{@item2.id}/edit")
    fill_in :name, with: "Hornswoggle"
    fill_in :inventory, with: "-1"

    click_button('Update Item')
    expect(page).to have_content("Price is not a number and Inventory must be greater than 0")
  end
end
