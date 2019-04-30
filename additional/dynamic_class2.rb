#https://johnragan.wordpress.com/2010/02/18/ruby-metaprogramming-dynamically-defining-classes-and-methods/
class ClassFactory
  def self.create_class(new_class, *fields)
    c = Class.new do
      fields.each do |field|
        define_method field.intern do
          instance_variable_get("@#{field}")
        end
        define_method "#{field}=".intern do |arg|
          instance_variable_set("@#{field}", arg)
        end
      end
    end

    Kernel.const_set new_class, c
  end
end

ClassFactory.create_class "Car", "make", "model", "year"

new_car = Car.new
new_car.make = "Nissan"
puts new_car.make # => "Nissan"
new_car.model = "Maxima"
puts new_car.model # => "Maxima"
new_car.year = "2001"
puts new_car.year # => "2001"

#list all the instance variables (the ones used to assign values above)
puts new_car.instance_variables

#instance variables are stored in a list
puts new_car.instance_variables[1]

#the index of a specific instance variable can be found as:
puts new_car.instance_variables.index(@model)

#alternatively the index of a specific instance variable can be found as:
puts new_car.instance_variables.index("@make".to_sym)

#assign intance variable value:
new_car.instance_variable_set('@model',"Altima")
#assign intance variable value:
new_car.instance_variable_set('@model'.to_sym,"Altima")
#instance variables cannot be named using spaces or other symbols (eg /)
