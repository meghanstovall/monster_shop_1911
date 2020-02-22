require 'rails_helper'

RSpec.describe 'Cart inrementation' do
    before(:each) do
      @mike = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @paper = @mike.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 3)
      @pencil = @mike.items.create(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)

      visit "/items/#{@paper.id}"
      click_on "Add To Cart"
      visit "/items/#{@pencil.id}"
      click_on "Add To Cart"
      expect(page).to have_content("Cart: 2")

      visit '/cart'
    end

    it "has a button to increment number of each item in cart" do

      within "#cart-item-#{@paper.id}" do
        expect(page).to have_link('+')
        expect(page).to have_link('-')
      end

      within "#cart-item-#{@pencil.id}" do
        expect(page).to have_link('+')
        expect(page).to have_link('-')
      end
    end

    it "cannot increment beyond the max in stock for each item" do

      within "#item-quantity-#{@paper.id}" do
        expect(page).to have_content("1")
      end

      within "#cart-item-#{@paper.id}" do
        click_on '+'
        expect(current_path).to eq('/cart')
      end

      within "#item-quantity-#{@paper.id}" do
        expect(page).to have_content("2")
      end

      within "#cart-item-#{@paper.id}" do
        click_on '+'
      end

      within "#item-quantity-#{@paper.id}" do
        expect(page).to have_content("3")
      end

      within "#cart-item-#{@paper.id}" do
        click_on '+'
      end

      expect(current_path).to eq('/cart')
      expect(page).to have_content("Out of Stock")
    end

    it 'I can decrement the item until it is removed from my cart' do

      within "#item-quantity-#{@paper.id}" do
        expect(page).to have_content("1")
      end

      within "#cart-item-#{@paper.id}" do
        click_on '+'
      end

      within "#item-quantity-#{@paper.id}" do
        expect(page).to have_content("2")
      end

      within "#cart-item-#{@paper.id}" do
        click_on '-'
        expect(current_path).to eq('/cart')
        expect(page).to have_content("1")
      end

      within "#cart-item-#{@paper.id}" do
        click_on '-'
        expect(current_path).to eq('/cart')
      end
      
      expect(page).to have_content("Item has been removed from the cart")
      expect(page).not_to have_css("cart-item-#{@paper.id}")
    end

    it 'I see information telling me I must register or log in to finish checking out' do
      expect(page).to have_content("Warning: You must register or log in to finish the checkout process")
    end
  end
