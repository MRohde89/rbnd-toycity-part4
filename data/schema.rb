# This file contains instructions for how to create a database.
# If the file does not exist yet, it opens a new writable file
# and adds a header for the columns: id, brand, product, price

def db_create
  data_path = "/media/sf_Nanodegree_Ruby/toycity_4/rbnd-toycity-part4/data/data.csv" 
  #File.dirname(__FILE__) + "/data.csv"
  if !File.exist?(data_path)
    CSV.open(data_path, "a+") do |csv|
      csv << ["id", "brand", "product", "price"]
    end
  end
end
