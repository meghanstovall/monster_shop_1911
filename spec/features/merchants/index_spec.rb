require 'rails_helper'

RSpec.describe 'merchant index page', type: :feature do
  describe 'As a user' do
    before :each do
      @bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Richmond', state: 'VA', zip: 80203)
      @dog_shop = Merchant.create(name: "Meg's Dog Shop", address: '123 Dog Rd.', city: 'Hershey', state: 'PA', zip: 80203)
    end

    it 'I can see a list of merchants in the system' do
      visit '/merchants'

      expect(page).to have_link("Brian's Bike Shop")
      expect(page).to have_link("Meg's Dog Shop")
    end

    it 'I can see a link to create a new merchant' do
      visit '/merchants'
      expect(page).to have_link("New Merchant")

      click_on "New Merchant"
      expect(current_path).to eq("/merchants/new")
    end
  end

  describe "as a merchant" do
    before :each do
      @bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Richmond', state: 'VA', zip: 80203)
      @dog_shop = Merchant.create(name: "Meg's Dog Shop", address: '123 Dog Rd.', city: 'Hershey', state: 'PA', zip: 80203)
      @user_1 = User.create!(
        name: "Peter Webber",
        street_address: "30 Girls Street",
        city: "Los Angeles",
        state: "CA",
        zip: 90036,
        email: "pilotpete@gmail.com",
        password: "password1",
        password_confirmation: "password1",
        role: 3)
      @pull_toy = @dog_shop.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
      @dog_bone = @dog_shop.items.create(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:true, inventory: 21)
      @tire = @bike_shop.items.create(name: "Bike Tire", description: "High quality", price: 40, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:true, inventory: 21)
      @seat = @bike_shop.items.create(name: "Bike Seat", description: "Very comfortable!", price: 20, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:true, inventory: 21)
    end

    it "as an admin, can disable a merchant" do
      visit "/login"

      fill_in :email, with: @user_1.email
      fill_in :password, with: @user_1.password
      click_button "Log In"

      visit "/admin/merchants"

      click_link "#{@dog_shop.name}"
      expect(current_path).to eq("/admin/merchants/#{@dog_shop.id}")

      visit "/admin/merchants"

      within "#merchant-#{@bike_shop.id}" do
        click_button "Disable"
        expect(current_path).to eq("/admin/merchants")
        expect(page).to have_content("Disabled: true")
      end

      expect(page).to have_content("Merchant has been disabled")
    end

    it "merchant items deactivated once disabled" do
      visit "/login"

      fill_in :email, with: @user_1.email
      fill_in :password, with: @user_1.password
      click_button "Log In"

      visit "/admin/merchants"

      within "#merchant-#{@bike_shop.id}" do
        click_button "Disable"
        expect(current_path).to eq("/admin/merchants")
        expect(page).to have_content("Disabled: true")
      end

      expect(@bike_shop.items.first.active?).to eq(false)
      expect(@bike_shop.items.last.active?).to eq(false)
    end

    it "can enabl already disabled merchants" do
      visit "/login"

      fill_in :email, with: @user_1.email
      fill_in :password, with: @user_1.password
      click_button "Log In"

      visit "/admin/merchants"

      within "#merchant-#{@bike_shop.id}" do
        click_button "Disable"
        expect(current_path).to eq("/admin/merchants")
      end

      visit "/admin/merchants"

      within "#merchant-#{@bike_shop.id}" do
        click_button "Enable"
        expect(current_path).to eq("/admin/merchants")
        expect(page).to have_content("Disabled: false")
      end
      expect(page).to have_content("Merchant has been enabled")
    end
  end
end
