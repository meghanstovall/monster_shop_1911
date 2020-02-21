require 'rails_helper'

describe Item, type: :model do
  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :description }
    it { should validate_presence_of :price }
    it { should validate_presence_of :image }
    it { should validate_presence_of :inventory }
    it { should validate_inclusion_of(:active?).in_array([true,false]) }
  end

  describe "relationships" do
    it {should belong_to :merchant}
    it {should have_many :reviews}
    it {should have_many :item_orders}
    it {should have_many(:orders).through(:item_orders)}
  end

  describe "instance methods" do
    before(:each) do
      @bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @chain = @bike_shop.items.create(name: "Chain", description: "It'll never break!", price: 50, image: "https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588", inventory: 5)

      @review_1 = @chain.reviews.create(title: "Great place!", content: "They have great bike stuff and I'd recommend them to anyone.", rating: 5)
      @review_2 = @chain.reviews.create(title: "Cool shop!", content: "They have cool bike stuff and I'd recommend them to anyone.", rating: 4)
      @review_3 = @chain.reviews.create(title: "Meh place", content: "They have meh bike stuff and I probably won't come back", rating: 1)
      @review_4 = @chain.reviews.create(title: "Not too impressed", content: "v basic bike shop", rating: 2)
      @review_5 = @chain.reviews.create(title: "Okay place :/", content: "Brian's cool and all but just an okay selection of items", rating: 3)
    end

    it "calculate average review" do
      expect(@chain.average_review).to eq(3.0)
    end

    it "sorts reviews" do
      top_three = @chain.sorted_reviews(3,:desc)
      bottom_three = @chain.sorted_reviews(3,:asc)

      expect(top_three).to eq([@review_1,@review_2,@review_5])
      expect(bottom_three).to eq([@review_3,@review_4,@review_5])
    end

    it 'no orders' do
      expect(@chain.no_orders?).to eq(true)
      order = Order.create(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033)
      order.item_orders.create(item: @chain, price: @chain.price, quantity: 2)
      expect(@chain.no_orders?).to eq(false)
    end
  end

  describe "class methods" do
    before(:each) do
      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @brian = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)
      @tire = @meg.items.create(name: "Tire", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      @tire_pump = @meg.items.create(name: "Tire Pump", description: "They'll love it!", price: 8, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)
      @bike_seat = @meg.items.create(name: "Bike Shop", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)
      @pull_toy = @brian.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
      @dog_bone = @brian.items.create(name: "Dog Bone", description: "They'll love it!", price: 8, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)
      @dog_bed = @brian.items.create(name: "Dog Bed", description: "They'll love it!", price: 15, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)
      @dog_dish = @brian.items.create(name: "Dog Dish", description: "They'll love it!", price: 5, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)

      @order_1 = Order.create(name: "Meg", address: "123 Turing St", city: "Denver", state: "CO", zip: "80020")
      @order_2 = Order.create(name: "Mike", address: "123 Turing St", city: "Denver", state: "CO", zip: "80020")

      @tire_order = ItemOrder.create(order_id: @order_1.id, item_id: @tire.id, price: 100, quantity: 8)
      @tire_pump_order = ItemOrder.create(order_id: @order_1.id, item_id: @tire_pump.id, price: 8, quantity: 7)
      @bike_seat_order = ItemOrder.create(order_id: @order_2.id, item_id: @bike_seat.id, price: 21, quantity: 6)
      @pull_toy_order = ItemOrder.create(order_id: @order_2.id, item_id: @pull_toy.id, price: 10, quantity: 5)
      @dog_bone_order = ItemOrder.create(order_id: @order_1.id, item_id: @dog_bone.id, price: 8, quantity: 4)
      @dog_bed_order = ItemOrder.create(order_id: @order_2.id, item_id: @dog_bed.id, price: 15, quantity: 3)
      @dog_dish_order = ItemOrder.create(order_id: @order_2.id, item_id: @dog_dish.id, price: 5, quantity: 3)
    end

    it "can find most popular items" do
      expect(Item.most_popular).to eq([@tire, @tire_pump, @bike_seat, @pull_toy, @dog_bone])
    end

    it "can find least popular items" do
      expect(Item.least_popular).to eq([@dog_dish, @dog_bed, @dog_bone, @pull_toy, @bike_seat])
    end
  end
end
