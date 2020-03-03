class Cart
  attr_reader :contents

  def initialize(contents)
    @contents = contents
  end

  def add_item(item)
    @contents[item] = 0 if !@contents[item]
    @contents[item] += 1
  end

  def total_items
    @contents.values.sum
  end

  def items
    item_quantity = {}
    @contents.each do |item_id, quantity|
      item_quantity[Item.find(item_id)] = quantity
    end
    item_quantity
  end

  def subtotal(item)
    if highest_discount(item) != nil
      discounted(item)
    else
      item.price * @contents[item.id.to_s]
    end
  end

  def highest_discount(item)
    ordered_discounts = item.discounts.order(min_quantity: :desc)
    new_discount = nil
    ordered_discounts.each do |discount|
      if @contents[item.id.to_s] >= discount.min_quantity
        new_discount = discount
        break
      end
    end
    new_discount
  end

  def discounted(item)
    price = item.price * @contents[item.id.to_s]
    to_percentage = (highest_discount(item).percent_off) / 100.to_f
    price - (price * to_percentage)
  end

  def total
    @contents.sum do |item_id, quantity|
      item = Item.find(item_id)
      if highest_discount(item) != nil
        discounted(item)
      else
        item.price * quantity
      end
    end
  end
end
