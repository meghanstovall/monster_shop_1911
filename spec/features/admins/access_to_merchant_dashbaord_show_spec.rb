# require 'rails_helper'
#
# RSpec.describe 'As an admin' do
#   context 'I can access the merchant dashboard' do
#     before :each do
#     @bike_shop = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
#     @merchant_user = User.create!(name: "Ben",street_address: "891 Penn St. Denver, CO",
#                               city: "denver",state: "CO",zip: "80206",email: "new_email2@gmail.com",password: "hamburger2", role: 2)
#     @admin_user = User.create!(name: "John",street_address: "123 Colfax St. Denver, CO",
#                               city: "denver",state: "CO",zip: "80206",email: "new_email3@gmail.com",password: "hamburger3", role: 3)
#     @bike_shop.users << @merchant_user
#     end
#
#     visit "/merchant/dashboard/#{@merchant_user.id}"
#
#
#   end
# end

# As a merchant employee
# When I visit my merchant dashboard ("/merchant")
# I see the name and full address of the merchant I work for
