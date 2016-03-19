require 'csv'
require_relative 'udacidata'

class Product < Udacidata
  attr_accessor :price, :id, :brand, :name
  attr_reader :products

# file_path = File.dirname(__FILE__) + "/../data/data.csv"
# if File.exist?(file_path)
#   @data_array = CSV.read(file_path)
#   @@products = []
#     #Product.create(id: row[0], brand: row[1], name: row[2], price: row[3])
# else
# end

@@products = []
@db_load = 0

  def initialize(opts={})
    # Get last ID from the database if ID exists
    self.class.load_from_db_if_exist
    get_last_id unless opts[:id]
    # Set the ID if it was passed in, otherwise use last existing ID
    @id = opts[:id] ? opts[:id].to_i : @@count_class_instances
    # Increment ID by 1
    auto_increment if !opts[:id]
    # Set the brand, name, and price normally
    @brand = opts[:brand]
    @name = opts[:name]
    @price = opts[:price]
    @@products << self
  end

  def self.load_from_db_if_exist
    file = File.dirname(__FILE__) + "/../data/data.csv"
    if File.exist?(file) && @db_load == 0
      data_array = CSV.readlines(file)
      data_array.each do |row|
        @db_load = 1
        puts "loading #{row[0]}"
        self.new(id: row[0], brand: row[1], name: row[2], price: row[3])
      end
    end
  end


  def self.create(*args, &block)
    new_product = self.new(*args, &block)
    Udacidata.save_to_file([new_product.id, new_product.brand, new_product.name, new_product.price])
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

  def self.check_if_id_exists(id)
    return @@products.map {|product| product.id}.include? (id)
  end

  def self.find(id)
    if check_if_id_exists(id)
      then return @@products[id-1]
    else raise ProductNotFoundError, "this product ID does not exist!"
    end
  end

  def self.destroy(index)
    if check_if_id_exists(index)
      then
        Udacidata.delete_from_file(index)
        deleted = @@products.delete_at(index-1)
        return deleted
      else
        raise ProductNotFoundError, "this product ID can not be deleted because it does not exist!"
      end
  end

  # where clause works also with multiple selections!
  def self.where(opts={})
    filtered_products = @@products
    opts.length.times do |index|
      filtered_products.select! {|element| eval("element.#{opts.keys[index]} == '#{opts.values[index]}'")}
    end
    return filtered_products
  end

  def update(opts={})
    self.class.update_row_in_self(self.id, opts)
    self.class.update_row_in_db(self)
    return self.class.all[self.id-1]
  end

  def self.update_row_in_self(id,opts)
    opts.length.times do |index|
      eval("@@products[id-1].#{opts.keys[index]} = '#{opts.values[index]}'")  if opts.keys[index] != "price"
      eval("@@products[id-1].#{opts.keys[index]} = #{opts.values[index]}")  if opts.keys[index] == "price"
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
