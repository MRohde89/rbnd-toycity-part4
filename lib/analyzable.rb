module Analyzable

  def average_price(products)
    entries = products.length
    prices = products.map { |product| product.price.to_f}
    average = (prices.inject(:+) / entries).round(2)
  end

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

  def count_by_brand(products)
    count_hash = Hash.new(0)
    products.each do |product|
      count_hash[product.brand] += 1
    end
    puts count_hash
    return count_hash
  end

  def count_by_name(products)
    count_hash = Hash.new(0)
    products.each do |product|
      count_hash[product.name] += 1
    end
    return count_hash
  end


## i would have liked to do this with metaprogramming, but i didn't figured out
## how i could create this within a module.
## if you know how to do this please let me know, because i really like
## the ability that metaprogramming provides! :-)
  # def create_count_methods(*attributes)
  #   attributes.each do |attribute|
  #     instance_eval("
  #     def count_by_#{attribute}(products)
  #       count_hash = Hash.new(0)
  #       products.each do |product|
  #         count_hash[product.#{attribute}] += 1
  #       end
  #       return count_hash
  #     end
  #     ")
  #   end
  # end
  # this should be called somewhere in order to use it in the module, but i
  # couldn't figure out where!


end
