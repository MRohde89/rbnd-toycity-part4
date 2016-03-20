require_relative 'find_by'
require_relative 'errors'
require 'csv'

class Udacidata

# data_path as class variable because it is used in every instance!
@@data_path = File.dirname(__FILE__) + "/../data/data.csv"
# create finder methods (see find_by.rb)
Udacidata.create_finder_methods("brand","name")

  # load entries from csv file
  # used in the Product Class before initializing to load the data just once!
  def self.load_from_csv
    database = []
    if File.exist?(@@data_path)
      csv_file = CSV.readlines(@@data_path, {:headers => true })
      # create database array which has every csv row as an array
      csv_file.each do |row|
        database << [row[0], row[1], row[2], row[3]]
      end
    end
    return database
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
