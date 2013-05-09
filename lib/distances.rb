require_relative 'person'
require_relative 'cluster'

class Distances
  attr_accessor :distances

  # [[     , (1,1), (2,1), (3,1), (4,1), (5,1)],
  #  [(1,1),      ,    x ,    x ,    x ,    x ],
  #  [(2,1),      ,      ,    x ,    x ,    x ],
  #  [(3,1),      ,      ,      ,    x ,    x ],
  #  [(4,1),      ,      ,      ,      ,    x ],
  #  [(5,1),      ,      ,      ,      ,      ]]
  #
  # ...after a round...
  #
  # [[     , (1,1), (2,1),      , (4,2), (5,1)],
  #  [(1,1),      ,    x ,      , m(xx),    x ],
  #  [(2,1),      ,      ,      , m(xx),    x ],
  #  [(3,1),      ,      ,      , m( x),    x ],
  #  [(4,1),      ,      ,      ,      ,    x ],
  #  [(5,1),      ,      ,      ,      ,      ]]

  def initialize
    fill_distances
  end

  def write
    JSON.dump(distances, File.open("distances.json", "w"))
  end

  def load
    self.distances = JSON.load(File.read("distances.json"))
  end

  def []=(a1, a2, value)
    self.distances   ||= [people.map {|a| Cluster.new_for_person(a)}]
    distances[a1.id] ||= [Cluster.new_for_person(a1)]
    distances[a1.id][a2.id] = value
  end

  def [](a1, a2)
    distances[a1.id][a2.id]
  end

  def each_with_index(&block)
    distances[1..-1].each_with_index do |sub_array, i|
      sub_array[1..-1].each_with_index do |distance, j|
        next if i == j
        block.call(distance, i, j)
      end
    end
  end

  private

  def fill_distances
    people.each do |person|
      people.each do |other_person|
        self[person, other_person] = person - other_person
      end
    end
  end

  def people
    Person.load_all
  end
end
