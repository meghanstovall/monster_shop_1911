require 'rails_helper'

RSpec.describe Discount, type: :model do
  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :percent_off }
    it { should validate_presence_of :min_quantity }
  end

  describe "relationships" do
    it {should belong_to :merchant}
    it {should have_many :item_discounts}
    it {should have_many(:items).through(:item_discounts)}
  end
end
