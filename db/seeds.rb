# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Merchant.destroy_all
Item.destroy_all

#merchants
bike_shop = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
dog_shop = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)

#bike_shop items
tire = bike_shop.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)

#dog_shop items
pull_toy = dog_shop.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
dog_bone = dog_shop.items.create(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)
dog_bath = dog_shop.items.create(name: "Bath", description: "They'll be clean!", price: 50, image: "https://naturaldogcompany.com/wp-content/uploads/2018/03/dog-bubble-bath-web.jpg", active?:false, inventory: 21)
chuck_it = dog_shop.items.create(name: "Chuck It", description: "They'll fetch it!", price: 10, image: "https://www.halfmoonoutfitters.com/assets/images/jumbos/lib_chuckit_lg.jpg", active?:false, inventory: 21)
frisbee = dog_shop.items.create(name: "Frisbee", description: "They fly far!", price: 5, image: "https://www.gophersport.com/cmsstatic/img/918/G-10395-FrisbeeFreestyle-features-01-clean.jpg", active?:false, inventory: 21)
