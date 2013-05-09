class Answer
  include Math
  attr_accessor :hash
  def initialize(h)
    raise "What?" if h.nil?
    self.hash = h
  end

  def to_json(*a)
    { json_class: "Answer", data: self.hash }.to_json(*a)
  end

  def self.json_create(o)
    new(*o['data'])
  end

  def self.load_all
    @answers ||= JSON.load(File.read("answers.json")).map {|hash| Answer.new(hash)}
  end

  def self.write(entries)
    JSON.dump(entries, File.open("answers.json", "w"))
  end

  def -(other_answer)
    distance = sqrt((age - other_answer.age)**2 + (countries - other_answer.countries)**2)
    %i(testing drink lang eat fun guns).each do |metric|
      distance += 10 if send(metric) != other_answer.send(metric)
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

end
