#!/usr/bin/env ruby

class Person
  ['age', 'name', 'favorite_color'].each do |attribute|
    ['with', 'and'].each do |prefix|
      class_eval %Q(
        def #{prefix}_#{attribute}(value)
          @#{attribute} = value
          self
        end
      )
    end
  end

  def to_s
    "Name: #@name, Age: #@age, Favorite Color: #@favorite_color"
  end
end

me = Person.new.
  with_name('Michael').
  and_age(22).
  and_favorite_color('Blue')

puts me.to_s # => Name: Michael, Age: 22, Favorite Color: Blue
