require_relative 'count_by'

module Analyzable

# creates count_by methods for Analyzable class.
# please see code in count_by.rb
Analyzable.create_count_methods("brand", "name")

  # calculates the average price of all given products
  def average_price(products)
    entries = products.length
    prices = products.map { |product| product.price.to_f}
    average = (prices.inject(:+) / entries).round(2)
  end

  #prints beautiful report to the command line ;-)
  def print_report(products)
    puts "Inventory by Brand:"
    brands = count_by_brand(products)
    brands.each do |key, value|
      puts "\t - #{key}: #{value}"
    end
    puts "Inventory by Name:"
    names = count_by_name(products)
    names.each do |key, value|
      puts "\t - #{key}: #{value}"
    end
    return "Average Price: #{average_price(products)}"
  end

end
