require 'csv'
require_relative 'udacidata'

class Product < Udacidata
  attr_accessor :price, :id, :brand, :name, :products

# database_loading return an array out of every csv/database row from previous workings
@@database_loading = Udacidata.load_from_csv
# @@products class will be filled with an empty array
@@products = []



  def initialize(opts={})
    # Get last ID from the database if ID exists
    # only return last_id if id is not provided
    get_last_id unless opts[:id]
    # empty @@products array if there is no existing file (sync)
    @@products = [] if get_last_id == 1
    # Set the ID if it was passed in, otherwise use last existing ID
    @id = opts[:id] ? opts[:id].to_i : @@count_class_instances
    # Increment ID by 1
    auto_increment if !opts[:id]
    # Set the brand, name, and price normally
    @brand = opts[:brand]
    @name = opts[:name]
    @price = opts[:price]
  end

  # to have a better overview of the products shown
  def to_s
    "id: #{@id}, brand: #{@brand}, name: #{@name}, price: #{@price};"
  end

  # will load from database/csv if it hasn't already loaded from the database
  def self.load_from_database
    # for every entry in database create a new product
    @@database_loading.each do |row|
      loaded_product = Product.new(id: row[0], brand: row[1].to_s, name: row[2].to_s, price: row[3])
      # add product to @@products array
      @@products << loaded_product
    end
    # after loading database_array will be set to nothing
    # in case load_from_database gets called more often, it will not iterate and add entries again
    @@database_loading = []
  end

  # create will look if there are database_entries before
  # it will then append the created product to the database/csv
  # afterwards it will save the entry in @@products
  def self.create(*args, &block)
    load_from_database
    new_product = self.new(*args, &block)
    Udacidata.save_to_file([new_product.id, new_product.brand, new_product.name, new_product.price])
    @@products << new_product
    # return the new product
    return new_product
  end

  # shows every entry from @@products
  # it will load every existing entry from the database beforehand
  def self.all
    load_from_database
    return @@products
  end

  # show first n rows of @@products
  def self.first(n = 0)
    return @@products[0] if n == 0
    return @@products[0..n-1] if n != 0
  end

  # show last n rows of @@products (ascending)
  def self.last(n = 0)
    return @@products[-1] if n == 0
    return @@products[-n..-1] if n != 0
  end

  # short check method if a given id is in @@product
  def self.id_exists?(id)
    return @@products.map {|product| product.id}.include? (id)
  end

  # find product based on id.
  # if id does not exists it will throw an error
  def self.find(id)
    if id_exists?(id)
      then return @@products.select { |product| product.id == id}[0]
    else raise ProductNotFoundError, "this product ID does not exist!"
    end
  end

  # destroy product based on id
  # will throw an error if the id doesn't exists
  def self.destroy(index)
    if id_exists?(index)
      then
        Udacidata.delete_from_file(index)
        # in order to return the deleted item it will be saved
        # (it will show the first entry that matches the condition)
        deleted = @@products.select {|product| product.id == index}[0]
        # delete all products with the id
        @@products.delete_if { |product| product.id == index}
        return deleted
      else
        raise ProductNotFoundError, "this product ID can not be deleted because it does not exist!"
      end
  end

  # where clause to get specific elements
  # also works with multiple selections!
  def self.where(opts={})
    filtered_product = @@products
    opts.length.times do |index|
      # will evaluate every given options.key to have the corresponding value
      filtered_product = filtered_product.select {|element| eval("element.#{opts.keys[index]} == '#{opts.values[index]}'")}
    end
    # return array of filtered products
    return filtered_product
  end

  # update database and @@products
  def update(opts={})
    self.class.update_row_in_self(self.id, opts) # function from Products
    self.class.update_row_in_db(self) # function from Udacidata
    return self
  end

  def self.update_row_in_self(id,opts)
    opts.length.times do |index|
      # look for @@product.id row and update the value with given options
      eval("@@products.select {|product| product.id == id}[0].#{opts.keys[index]} = '#{opts.values[index]}'")  if opts.keys[index] != "price"
      # second case in order to not save the price as a string
      eval("@@products.select {|product| product.id == id}[0].#{opts.keys[index]} = #{opts.values[index]}")  if opts.keys[index] == "price"
    end
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
