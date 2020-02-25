class AddImageToItems < ActiveRecord::Migration[5.1]
  def change
    add_column :items, :image, :string, default: "https://i.picsum.photos/id/866/200/300.jpg"
    Item.all.where(image: nil).update_all(image: "https://i.picsum.photos/id/866/200/300.jpg")
    Item.all.where(image: '').update_all(image: "https://i.picsum.photos/id/866/200/300.jpg")
  end
end
