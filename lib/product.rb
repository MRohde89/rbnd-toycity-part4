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
    save_to_file([@id, @brand, @name, @price])
  end

  def self.create(*args, &block)
    return self.new(*args, &block)
  end

  def self.all
    ##@@products = CSV.parse(@data_path, {:headers => true})
    return @@products
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
