class Module
  def create_finder_methods(*attributes)
    # Your code goes here!
    # Hint: Remember attr_reader and class_eval
    attributes.each do |finder|
      class_eval("
        def self.find_by_#{finder}(object_to_find)
          return self.all.select {|element| element.#{finder} == object_to_find}[0]
        end")
   end
  end
end
