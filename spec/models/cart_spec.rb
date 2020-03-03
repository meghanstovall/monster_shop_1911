require 'rails_helper'

RSpec.describe Cart, type: :model do
  describe "methods" do
    it "#discounted" do
      bike_shop = Merchant.create!(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Richmond', state: 'VA', zip: 23137)
      chain = bike_shop.items.create(name: "Chain", description: "It'll never break!", price: 40, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 100)

      discount_1 = bike_shop.discounts.create!(name: "5% Discount", percent_off: 5, min_quantity: 10)
      item_discount = ItemDiscount.create(item: chain, discount: discount_1)

      cart = Cart.new({chain.id.to_s => 10})

      expect(cart.discounted(chain)).to eq(380)
    end

    it "#highest_discount" do
      bike_shop = Merchant.create!(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Richmond', state: 'VA', zip: 23137)
      chain = bike_shop.items.create(name: "Chain", description: "It'll never break!", price: 40, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 100)

      discount_1 = bike_shop.discounts.create!(name: "5% Discount", percent_off: 5, min_quantity: 10)
      discount_2 = bike_shop.discounts.create!(name: "10% Discount", percent_off: 10, min_quantity: 30)
      item_discount = ItemDiscount.create(item: chain, discount: discount_1)
      item_discount = ItemDiscount.create(item: chain, discount: discount_2)

      cart = Cart.new({chain.id.to_s => 30})

      expect(cart.highest_discount(chain)).to eq(discount_2)
    end
  end
end
