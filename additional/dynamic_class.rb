# https://stackoverflow.com/questions/37364454/what-is-a-ruby-factory-method
class Person
  def initialize(attributes)
  end
end

class Boss
  def initialize(attributes)
  end
end

class Employee
  def initialize(attributes)
  end
end

class PersonFactory
  TYPES = {
    employee: Employee,
    boss: Boss
  }

  def self.for(type, attributes)
    (TYPES[type] || Person).new(attributes)
  end
end

employee = PersonFactory.for(:employee, name: 'Danny')
boss = PersonFactory.for(:boss, name: 'Danny')
person = PersonFactory.for(:foo, name: 'Danny')
	