require 'rails_helper'

RSpec.describe Order, type: :model do
  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :address }
    it { should validate_presence_of :city }
    it { should validate_presence_of :state }
    it { should validate_presence_of :zip }
  end

  describe "relationships" do
    it {should belong_to :user}
    it {should have_many :item_orders}
    it {should have_many(:items).through(:item_orders)}
  end

  describe 'instance methods' do
    before :each do
      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @brian = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)
      @mike = User.create(name: "Mike", street_address: '125 Turing St.', city: 'Denver', state: 'CO', zip: 80210, email: 'mike@gmail.com', password: 'password1', password_confirmation: 'password1')

      @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      @pull_toy = @brian.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)

      @order_1 = @mike.orders.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033)

      @order_1.item_orders.create!(item: @tire, price: @tire.price, quantity: 2, status: 1)
      @order_1.item_orders.create!(item: @pull_toy, price: @pull_toy.price, quantity: 3)
    end

    it '.grandtotal' do
      expect(@order_1.grandtotal).to eq(230)
    end

    it '.total_item_quantity' do
      expect(@order_1.total_item_quantity).to eq(5)
    end

    it '.cancel_process' do
      expect(@order_1.item_orders.first.status).to eq('fulfilled')
      expect(@order_1.item_orders.second.status).to eq('unfulfilled')
      expect(@order_1.status).to eq('pending')

      expect(@order_1.cancel_process.first.status).to eq('unfulfilled')
      expect(@order_1.cancel_process.second.status).to eq('unfulfilled')
      expect(@order_1.status).to eq('cancelled')
    end

    it '.fulfill' do
      expect(@order_1.item_orders.first.status).to eq('fulfilled')
      expect(@order_1.item_orders.second.status).to eq('unfulfilled')
      expect(@order_1.status).to eq('pending')

      expect(@order_1.fulfill).to eq(true)
      expect(@order_1.item_orders.first.status).to eq('fulfilled')
      expect(@order_1.item_orders.second.status).to eq('fulfilled')
      expect(@order_1.status).to eq('packaged')
    end

    it '.ship_and_fulfill' do
      expect(@order_1.item_orders.first.status).to eq('fulfilled')
      expect(@order_1.item_orders.second.status).to eq('unfulfilled')
      expect(@order_1.status).to eq('pending')

      expect(@order_1.ship_and_fulfill).to eq(true)
      expect(@order_1.item_orders.first.status).to eq('fulfilled')
      expect(@order_1.item_orders.second.status).to eq('fulfilled')
      expect(@order_1.status).to eq('shipped')
    end

    describe "Instance Methods" do
      it "#merchant_quantity" do
        expect(@order_1.merchant_quantity(@meg.id)).to eq(2)
      end

      it 'merchant total' do
        expect(@order_1.merchant_total(@meg.id)).to eq(200.0)
      end
    end
  end
end
