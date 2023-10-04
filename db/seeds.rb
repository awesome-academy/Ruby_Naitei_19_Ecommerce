# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

User.create!(name: "Example Admin",email: "admin@railstutorial.org",password: "foobar",password_confirmation: "foobar", role: "admin")
User.create!(name: "Example User",email: "user@railstutorial.org",password: "foobar",password_confirmation: "foobar", role: "user")
User.create!(name: "Example User 1",email: "user1@railstutorial.org",password: "foobar",password_confirmation: "foobar", role: "user")
User.create!(name: "Example User 2",email: "user2@railstutorial.org",password: "foobar",password_confirmation: "foobar", role: "user")


10.times do |n|
  category_name = "Category #{n+1}"
  description = "This is a category"

  Category.create!(category_name: category_name, description: description)
end

50.times do |n|
  name = "Product #{n+1}"
  price = rand(100000..3000000)
  description = "This is a product"
  category_id = rand(1..10)
  number = rand(0..100)

  Product.create!(name: name,price: price,description: description, number: number, category_id: category_id)
  4.times do |m|
    image = Faker::LoremFlickr.image(size: "500x500", search_terms: ['products'])
    product_id = n+1
    ProductImage.create!(image: image,product_id: product_id)
  end
end

10.times do |n|
  name = "Category #{n+1}"
  description = "This is a category"

  Category.create!(name: name, description: description)
end
