require_relative 'find_by'
require_relative 'errors'
require 'csv'

class Udacidata
  # Your code goes here!
Udacidata.create_finder_methods("brand","name")

  def initialize

  end

  def self.load_from_database
    data_path = File.dirname(__FILE__) + "/../data/data.csv"
    database = []
    if File.exist?(data_path)
      csv_file = CSV.readlines(data_path, {:headers => true })
      csv_file.each do |row|
        database << [row[0], row[1], row[2], row[3]]
      end
    end
    return database
  end


  # need to fix to write the header of the file first. if it exists
  def self.save_to_file(data_array)
    @data_path = File.dirname(__FILE__) + "/../data/data.csv"
    CSV.open(@data_path, "a+") do |csv|
       csv << data_array
     end
  end

  def self.delete_from_file(index)
    @data_path = File.dirname(__FILE__) + "/../data/data.csv"
    modified_array = []
    CSV.foreach(@data_path) do |line|
      modified_array << line if line[0] != index.to_s
    end
    File.delete(@data_path)
    modified_array.each do |line|
      save_to_file(line)
    end
  end

  def self.update_row_in_db(product)
    @data_path = File.dirname(__FILE__) + "/../data/data.csv"
    modified_array = []
    CSV.foreach(@data_path) do |line|
      modified_array << line if line[0] != product.id.to_s
      modified_array << [product.id, product.brand, product.name, product.price] if line[0] == product.id.to_s
    end
    File.delete(@data_path)
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
