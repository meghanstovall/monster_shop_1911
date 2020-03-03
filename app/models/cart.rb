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
    discounts = item.discounts.where("#{@contents[item.id.to_s]} >= discounts.min_quantity")
    discounts.order(percent_off: :desc).limit(1).first
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
