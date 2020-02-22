require 'rails_helper'

RSpec.describe User, type: :model do

	describe 'validations' do
		it {should validate_presence_of :name}
		it {should validate_presence_of :street_address}
		it {should validate_presence_of :city}
		it {should validate_presence_of :state}
		it {should validate_presence_of :zip}
		it {should validate_presence_of :email}
		it {should validate_presence_of :password}
		it {should validate_presence_of :role}

		it {should validate_uniqueness_of :email}
	end

	describe 'relationships' do
		it {should have_many :orders}
	end

  it "can be create roles" do
    user = User.create(email: "penelope",
                       password: "boom",
                       role:2)

    expect(user.role).to eq("merchant")
    expect(user.merchant?).to be_truthy
  end

  it "can be created as a default user" do
    user = User.create(email: "sammy",
                       password: "pass",
                       role: 0)

    expect(user.role).to eq("regular")
    expect(user.regular?).to be_truthy
  end
end
