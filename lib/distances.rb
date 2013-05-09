require_relative 'answer'
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
    self.distances   ||= [answers.map {|a| Cluster.new_for_person(a)}]
    distances[a1.id] ||= [Cluster.new_for_person(a1)]
    distances[a1.id][a2.id] = value
  end

  def [](a1, a2)
    distances[a1.id][a2.id]
  end

  private

  def fill_distances
    answers.each do |answer|
      answers.each do |other_answer|
        self[answer, other_answer] = answer - other_answer
      end
    end
  end

  def answers
    Answer.load_all
  end
end
