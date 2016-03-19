require 'csv'
require_relative 'udacidata'

class Product < Udacidata
  attr_reader :id, :price, :brand, :name, :products

@@products = []


  def initialize(opts={})
    # Get last ID from the database if ID exists
    @@products = [] if get_last_id == 1
    # Set the ID if it was passed in, otherwise use last existing ID
    @id = opts[:id] ? opts[:id].to_i : @@count_class_instances
    # Increment ID by 1
    auto_increment if !opts[:id]
    # Set the brand, name, and price normally
    @brand = opts[:brand]
    @name = opts[:name]
    @price = opts[:price]
    @@products << self
    self.class.save_to_file([@id, @brand, @name, @price])
  end

  def self.create(*args, &block)
    return self.new(*args, &block)
  end

  def self.all
    return @@products
  end

  def self.first(n = 0)
    return @@products[0] if n == 0
    return @@products[0..n-1] if n != 0
  end

  def self.last(n = 0)
    return @@products[-1] if n == 0
    return @@products[-n..-1] if n != 0
  end

  def self.find(index)
    return @@products[index-1]
  end

  def self.destroy(index)
    Udacidata.delete_from_file(index)
    deleted = @@products.delete_at(index-1)
    return deleted
  end

  # where clause works also with multiple selections!
  def self.where(opts={})
    filtered_products = @@products
    opts.length.times do |index|
      filtered_products.select! {|element| eval("element.#{opts.keys[index]} == '#{opts.values[index]}'")}
    end
    return filtered_products
  end

  private

    # Reads the last line of the data file, and gets the id if one exists
    # If it exists, increment and use this value
    # Otherwise, use 0 as starting ID number
    def get_last_id
      file = File.dirname(__FILE__) + "/../data/data.csv"
      last_id = File.exist?(file) ? CSV.read(file).last[0].to_i + 1 : nil
      @@count_class_instances = last_id || 0
    end

    def auto_increment
      @@count_class_instances += 1
    end

end
