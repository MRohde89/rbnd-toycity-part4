class Module
  # creates count_by methods with metaprogramming
  def create_count_methods(*attributes)
    attributes.each do |attribute|
      instance_eval("
      def count_by_#{attribute}(products)
        count_hash = Hash.new(0)
        products.each do |product|
          count_hash[product.#{attribute}] += 1
        end
        return count_hash
      end
      ")
    end
  end
end
