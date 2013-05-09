class Cluster
  attr_accessor :id, :size, :people

  def initialize(person)
    self.people = [person]
    self.id     = person.id
    self.size   = 1
  end
end
