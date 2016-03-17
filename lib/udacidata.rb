require_relative 'find_by'
require_relative 'errors'
require 'csv'

class Udacidata
  # Your code goes here!

  def save_to_file(data_array)
    @data_path = File.dirname(__FILE__) + "/../data/data.csv"
    CSV.open(@data_path, "a+") do |csv|
       csv << data_array
     end
  end


end
