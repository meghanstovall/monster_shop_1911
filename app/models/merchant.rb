class Merchant <ApplicationRecord
  has_many :items, dependent: :destroy
  has_many :item_orders, through: :items
  has_many :users
  has_many :discounts

  validates_presence_of :name,
                        :address,
                        :city,
                        :state,
                        :zip

  validates_inclusion_of :disabled, :in => [true, false]

  def no_orders?
    item_orders.empty?
  end

  def item_count
    items.count
  end

  def average_item_price
    items.average(:price)
  end

  def distinct_cities
    item_orders.distinct.joins(:order).pluck(:city)
  end

  def enable_disable
    if disabled == false
      update(disabled: true)
    else
      update(disabled: false)
    end
  end

  def deactivate_items
    items.update(active?: false)
  end

  def activate_items
    items.update(active?: true)
  end
end
