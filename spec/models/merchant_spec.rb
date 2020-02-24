require 'rails_helper'

describe Merchant, type: :model do
  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :address }
    it { should validate_presence_of :city }
    it { should validate_presence_of :state }
    it { should validate_presence_of :zip }
    it { should validate_inclusion_of(:disabled).in_array([true,false]) }
  end

  describe "relationships" do
    it {should have_many :items}
    it {should have_many :users}
  end

  describe 'instance methods' do
    before(:each) do
      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203, disabled: false)
      @tire = @meg.items.create(name: "Bike Tire", description: "High quality", price: 80, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      @seat = @meg.items.create(name: "Bike Seat", description: "Comfortable", price: 40, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
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
    end

    it 'no_orders' do
      expect(@meg.no_orders?).to eq(true)

      tim = User.create(name: 'Tim',
                      street_address: '123 Turing St',
                      city: 'Denver',
                      state: 'CO',
                      zip: '80020',
                      email: 'tim@gmail.com',
                      password: 'password1',
                      password_confirmation: "password1",
                      role: 1)
      order_1 = tim.orders.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033)
      item_order_1 = order_1.item_orders.create!(item: @tire, price: @tire.price, quantity: 2)

      expect(@meg.no_orders?).to eq(false)
    end

    it 'item_count' do
      chain = @meg.items.create(name: "Chain", description: "It'll never break!", price: 30, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 22)

      expect(@meg.item_count).to eq(3)
    end

    it 'average_item_price' do
      expect(@meg.average_item_price).to eq(60)
    end

    it 'distinct_cities' do
      chain = @meg.items.create(name: "Chain", description: "It'll never break!", price: 40, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 22)
      tim = User.create(name: 'Tim',
                      street_address: '123 Turing St',
                      city: 'Denver',
                      state: 'CO',
                      zip: '80020',
                      email: 'tim@gmail.com',
                      password: 'password1',
                      password_confirmation: "password1",
                      role: 1)
      order_1 = tim.orders.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033)
      order_2 = tim.orders.create!(name: 'Brian', address: '123 Brian Ave', city: 'Denver', state: 'CO', zip: 17033)
      order_3 = tim.orders.create!(name: 'Dao', address: '123 Mike Ave', city: 'Denver', state: 'CO', zip: 17033)
      order_1.item_orders.create!(item: @tire, price: @tire.price, quantity: 2)
      order_2.item_orders.create!(item: chain, price: chain.price, quantity: 2)
      order_3.item_orders.create!(item: @tire, price: @tire.price, quantity: 2)

      expect(@meg.distinct_cities).to eq(["Denver","Hershey"])
    end

    it "enable_disable" do
      expect(@meg.enable_disable).to eq(true)
      @meg.enable_disable
      expect(@meg.disabled).to eq(false)
    end

    it "deactivate_items" do
      @meg.deactivate_items

      expect(@tire.active?).to eq(false)
      expect(@seat.active?).to eq(false)
    end
  end
end
