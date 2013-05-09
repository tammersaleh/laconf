class Cluster
  MAX_SIZE = 5
  attr_accessor :id, :size, :people

  def self.new_for_person(person)
    new(person.id, 1, [person])
  end

  def self.json_create(o)
    new_from_json(*o['data'])
  end

  def initialize(id, size, people)
    self.id     = id
    self.size   = size
    self.people = people
  end

  def to_json(*a)
    { json_class: "Cluster", data: [ id, size, people ] }.to_json(*a)
  end

  def merge(other)
    self.people.unshift(*other.people)
    self.size += other.size
    raise "Oversized cluster created!" if size > MAX_SIZE
  end

  def mergable_with?(other)
    size + other.size <= MAX_SIZE
  end

  def full?
    size == MAX_SIZE
  end
end
