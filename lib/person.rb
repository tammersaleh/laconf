class Person
  include Math
  attr_accessor :hash
  def initialize(h)
    raise "What?" if h.nil?
    self.hash = h
  end

  def to_json(*a)
    { json_class: "Person", data: self.hash }.to_json(*a)
  end

  def self.json_create(o)
    new(*o['data'])
  end

  def self.load_all
    @people ||= JSON.load(File.read("people.json")).map {|hash| Person.new(hash)}
  end

  def self.write(entries)
    JSON.dump(entries, File.open("people.json", "w"))
  end

  def -(other_person)
    distance = sqrt((age - other_person.age)**2 + (countries - other_person.countries)**2)
    %i(testing drink lang eat fun guns).each do |metric|
      distance += 20 if send(metric) != other_person.send(metric)
    end
    return distance.ceil
  end

  def name
    hash["name"]
  end

  def id
    hash["id"].to_i
  end

  def age
    hash["age"].to_i
  end

  def countries
    hash["countries"].to_i
  end

  def testing
    hash["testing"]
  end

  def drink
    hash["drink"]
  end

  def lang
    hash["lang"]
  end

  def eat
    hash["eat"]
  end

  def fun
    hash["fun"]
  end

  def guns
    hash["guns"]
  end

  def to_s
    sprintf("%30s: %12s, %12s, %12s, %7s, %7s, %24s, %20s, %25s", 
            name, 
            "#{age} years old",
            "#{countries} visited",
            testing, 
            drink, 
            lang, 
            eat, 
            fun, 
            guns)
  end
end
