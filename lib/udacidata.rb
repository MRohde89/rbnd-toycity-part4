require_relative 'find_by'
require_relative 'errors'
require 'csv'

class Udacidata
  # Your code goes here!
Udacidata.create_finder_methods("brand","name")

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

end
