require_relative 'find_by'
require_relative 'errors'
require 'csv'

class Udacidata

# data_path as class variable because it is used in every instance!
@@data_path = File.dirname(__FILE__) + "/../data/data.csv"
@@products = []
# create finder methods (see find_by.rb)
Udacidata.create_finder_methods("brand","name")

  # load entries from csv file
  # used in the Product Class before initializing to load the data just once!
  def self.load_from_csv
    if File.exist?(@@data_path)
      csv_file = CSV.readlines(@@data_path, {:headers => true })
      @@products = []
      # create database array which has every csv row as an array
      csv_file.each do |row|
        @@products << Product.new({id: row[0], brand: row[1], name: row[2], price: row[3]})
      end
    end
    return @@products
  end


  # will append passed entry to the database
  def self.save_to_file(data_array)
    CSV.open(@@data_path, "a+") do |csv|
       csv << data_array
     end
  end

  # will delete given entry by creating a new array and overwriting the old csv
  def self.delete_from_file(index)
    modified_array = []
    CSV.foreach(@@data_path) do |line|
      modified_array << line if line[0] != index.to_s # save every line which has not the given id
    end
    # delete old file
    File.delete(@@data_path)
    # write new file without old entry
    modified_array.each do |line|
      save_to_file(line)
    end
  end

  # will update by overwriting an entry with the new data.
  # overwrites old csv with updated data csv
  def self.update_row_in_db(product)
    modified_array = []
    CSV.foreach(@@data_path) do |line|
      modified_array << line if line[0] != product.id.to_s
      modified_array << [product.id, product.brand, product.name, product.price] if line[0] == product.id.to_s
    end
    File.delete(@@data_path)
    modified_array.each do |line|
      save_to_file(line)
    end
  end

  # create will look if there are database_entries before
  # it will then append the created product to the database/csv
  # afterwards it will save the entry in @@products
  def self.create(*args, &block)
    self.load_from_csv
    new_product = Product.new(*args, &block)
    Udacidata.save_to_file([new_product.id, new_product.brand, new_product.name, new_product.price])
    @@products << new_product
    # return the new product
    return new_product
  end

  # shows every entry from @@products
  # it will load every existing entry from the database beforehand
  def self.all
    self.load_from_csv
    return @@products
  end

  # show first n rows of @@products
  def self.first(n = 0)
    self.load_from_csv
    return @@products[0] if n == 0
    return @@products[0..n-1] if n != 0
  end

  # show last n rows of @@products (ascending)
  def self.last(n = 0)
    self.load_from_csv
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
    self.load_from_csv
    if id_exists?(id)
      return @@products.select { |product| product.id == id}[0]
    else raise ProductNotFoundError, "this product ID does not exist!"
    end
  end
  # destroy product based on id
  # will throw an error if the id doesn't exists
  def self.destroy(index)
    self.load_from_csv
    if id_exists?(index)
      self.delete_from_file(index)
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
    self.load_from_csv
    filtered_product = @@products
    opts.each do |key, value|
      # will evaluate every given options.key to have the corresponding value
      filtered_product = filtered_product.select {|element| eval("element.#{key} == '#{value}'")} if key != "price"
      filtered_product = filtered_product.select {|element| eval("element.#{key} == #{value}")} if key == "price"
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

## unused sorting algorithm.
  # def self.sort_csv
  #   @data_path = File.dirname(__FILE__) + "/../data/data.csv"
  #   csv_file = CSV.read(@data_path)
  #   csv_file.sort! { |a, b| a[0] <=> b[0] }
  #   csv_file.open(@data_path, "w") do |csv|
  #     csv << csv_file
  #   end
  # end
end
