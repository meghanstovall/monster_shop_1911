require 'rails_helper'

RSpec.describe "Items Index Page" do
  describe "When I visit the items index page" do
    before(:each) do
      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @brian = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)
      @user = User.create!(name: "Jaffar",
        street_address: "789 Palace Street",
        city: "Detroit",
        state: "AZ",
        zip: 98345,
        email: "jaffar@gamil.com",
        password: "geniessuck",
        role: 0
       )

      @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      @tire_pump = @meg.items.create(name: "Tire Pump", description: "They'll love it!", price: 8, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)
      @bike_seat = @meg.items.create(name: "Bike Shop", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)
      @pull_toy = @brian.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
      @dog_bone = @brian.items.create(name: "Dog Bone", description: "They'll love it!", price: 8, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)
      @dog_bed = @brian.items.create(name: "Dog Bed", description: "They'll love it!", price: 15, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)
      @dog_dish = @brian.items.create(name: "Dog Dish", description: "They'll love it!", price: 5, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)
    end

    it "all items or merchant names are links" do
      visit '/items'

      expect(page).to have_link(@tire.name)
      expect(page).to have_link(@tire.merchant.name)
      expect(page).to have_link(@pull_toy.name)
      expect(page).to have_link(@pull_toy.merchant.name)
      expect(page).to have_link(@dog_bone.name)
      expect(page).to have_link(@dog_bone.merchant.name)
    end

    it "I can see a list of all of the items "do

      visit '/items'

      within "#item-#{@tire.id}" do
        expect(page).to have_link(@tire.name)
        expect(page).to have_content(@tire.description)
        expect(page).to have_content("Price: $#{@tire.price}")
        expect(page).to have_content("Active")
        expect(page).to have_content("Inventory: #{@tire.inventory}")
        expect(page).to have_link(@meg.name)
        expect(page).to have_css("img[src*='#{@tire.image}']")
      end

      within "#item-#{@pull_toy.id}" do
        expect(page).to have_link(@pull_toy.name)
        expect(page).to have_content(@pull_toy.description)
        expect(page).to have_content("Price: $#{@pull_toy.price}")
        expect(page).to have_content("Active")
        expect(page).to have_content("Inventory: #{@pull_toy.inventory}")
        expect(page).to have_link(@brian.name)
        expect(page).to have_css("img[src*='#{@pull_toy.image}']")
      end

      within "#item-#{@dog_bone.id}" do
        expect(page).to have_link(@dog_bone.name)
        expect(page).to have_content(@dog_bone.description)
        expect(page).to have_content("Price: $#{@dog_bone.price}")
        expect(page).to have_content("Inactive")
        expect(page).to have_content("Inventory: #{@dog_bone.inventory}")
        expect(page).to have_link(@brian.name)
        expect(page).to have_css("img[src*='#{@dog_bone.image}']")
      end
    end

    it "can see all items when visiting the show page" do

      visit "/items"

      within "#item-#{@tire.id}" do
        expect(page).to have_content(@tire.name)
        expect(page).to have_css("img[src*='#{@tire.image}']")

        find(:xpath, "//a/img[@alt='#{@tire.id}']/..").click
        expect(current_path).to eq("/items/#{@tire.id}")
      end

      visit "/items"

      within "#item-#{@pull_toy.id}" do
        expect(page).to have_content(@pull_toy.name)
        expect(page).to have_css("img[src*='#{@pull_toy.image}']")

        find(:xpath, "//a/img[@alt='#{@pull_toy.id}']/..").click
        expect(current_path).to eq("/items/#{@pull_toy.id}")
      end

      visit "/items"

      within "#item-#{@dog_bone.id}" do
        expect(page).to have_content(@dog_bone.name)
        expect(page).to have_css("img[src*='#{@dog_bone.image}']")

        find(:xpath, "//a/img[@alt='#{@dog_bone.id}']/..").click
        expect(current_path).to eq("/items/#{@dog_bone.id}")
      end
    end

    it "can see stats for top 5 most popular and least 5 popular" do
      order_1 = Order.create(name: "Meg", address: "123 Turing St", city: "Denver", state: "CO", zip: "80020")
      order_2 = Order.create(name: "Mike", address: "123 Turing St", city: "Denver", state: "CO", zip: "80020")

      tire_order = ItemOrder.create(order_id: order_1.id, item_id: @tire.id, price: 100, quantity: 8)
      tire_pump_order = ItemOrder.create(order_id: order_1.id, item_id: @tire_pump.id, price: 8, quantity: 7)
      bike_seat_order = ItemOrder.create(order_id: order_2.id, item_id: @bike_seat.id, price: 21, quantity: 6)
      pull_toy_order = ItemOrder.create(order_id: order_2.id, item_id: @pull_toy.id, price: 10, quantity: 5)
      dog_bone_order = ItemOrder.create(order_id: order_1.id, item_id: @dog_bone.id, price: 8, quantity: 4)
      dog_bed_order = ItemOrder.create(order_id: order_2.id, item_id: @dog_bed.id, price: 15, quantity: 3)
      dog_dish_order = ItemOrder.create(order_id: order_2.id, item_id: @dog_dish.id, price: 5, quantity: 2)

      visit "/items"

      within "#most-popular" do
        expect(page).to have_content("Most Popular Items")
        expect(page). to have_content("#{@tire.name}, 8 purchased")
        expect(page). to have_content("#{@tire_pump.name}, 7 purchased")
        expect(page). to have_content("#{@bike_seat.name}, 6 purchased")
        expect(page). to have_content("#{@pull_toy.name}, 5 purchased")
        expect(page). to have_content("#{@dog_bone.name}, 4 purchased")
      end

      within "#least-popular" do
        expect(page).to have_content("Least Popular Items")
        expect(page). to have_content("#{@dog_dish.name}, 2 purchased")
        expect(page). to have_content("#{@dog_bed.name}, 3 purchased")
        expect(page). to have_content("#{@dog_bone.name}, 4 purchased")
        expect(page). to have_content("#{@pull_toy.name}, 5 purchased")
        expect(page). to have_content("#{@bike_seat.name}, 6 purchased")
      end
    end
  end
end
