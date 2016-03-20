require 'faker'

# This file contains code that populates the database with
# fake data for testing purposes

# create from faker Commerce plugin: Names, departments, prices
def db_seed
  10.times do
    Product.create(
      brand: Faker::Commerce.department,
      name: Faker::Commerce.product_name,
      price: Faker::Commerce.price)
    end
end
