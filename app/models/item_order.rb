class ItemOrder <ApplicationRecord
  validates_presence_of :item_id, :order_id, :price, :quantity

  belongs_to :item
  belongs_to :order
  before_save :default_values

  enum status: %w(fulfilled unfulfilled)

  def subtotal
    price * quantity
  end

  def default_values
    self.status = 0
  end
  
end
