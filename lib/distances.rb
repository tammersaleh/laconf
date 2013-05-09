require_relative 'person'
require_relative 'cluster'

class Distances
  attr_accessor :distances

  def initialize(people)
    self.distances = [[nil] + people.map {|a| Cluster.new_for_person(a)}]
    people.each do |person|
      distances[person.id] ||= [Cluster.new_for_person(person)]
    end
    fill_distances(people)
  end

  def write
    JSON.dump(distances, File.open("distances.json", "w"))
  end

  def load
    self.distances = JSON.load(File.read("distances.json"))
  end

  def []=(a1, a2, value)
    distances[a1.id][a2.id] = value
  end

  def [](a1, a2)
    distances[a1.id][a2.id]
  end

  def each_with_clusters(&block)
    distances.each_with_index do |sub_array, i|
      sub_array.each_with_index do |distance, j|
        next if i == 0
        next if j == 0
        next if i == j
        assert(distances[i][0], "distances[#{i}][0] is nil.")
        assert(distances[0][j], "distances[0][#{j}] is nil.")
        block.call(distance, distances[i][0], distances[0][j])
      end
    end
  end

  # [[     , (1,1), (2,1), (3,1), (4,1), (5,1)],
  #  [(1,1),      ,      ,      ,      ,      ],
  #  [(2,1),    x ,      ,      ,      ,      ],
  #  [(3,1),    x ,    x ,      ,      ,      ],
  #  [(4,1),    x ,    x ,    x ,      ,      ],
  #  [(5,1),    x ,    x ,    x ,    x ,      ]]
  #
  # ...after a round...
  #
  # [[     , (1,1), (2,1), (4,2), (5,1)],
  #  [(1,1),      ,      ,      ,      ],
  #  [(2,1),    x ,      ,      ,      ],
  #  [(4,2),  min ,  min ,      ,      ],
  #  [(5,1),    x ,    x ,    x ,      ]]

  def merge_clusters!(cluster1_id, cluster2_id)
    c1_index = index(cluster1_id)
    c2_index = index(cluster2_id)

    distances[c2_index][1..-1] = linkage(distances[c1_index][1..-1],
                                         distances[c2_index][1..-1])
    distances[c2_index][0].merge(distances[0][c1_index])
    distances[0][c2_index] = distances[c2_index][0]

    distances.delete_at(c1_index)
    distances.each do |row|
      row.delete_at(c1_index)
      assert(row.length == distances.length, "Lengths don't match.")
    end
  end

  def linkage(ary1, ary2)
    # http://en.wikipedia.org/wiki/Complete-linkage_clustering
    ary1.zip(ary2).map(&:max)
  end

  def assert(value, message)
    raise message unless value
  end

  def done?
    unfilled_clusters = clusters.reject(&:full?)
    return true if unfilled_clusters.size < 2
    smallest_two = unfilled_clusters.sort[0..1]
    return false if smallest_two[0].mergable_with?(smallest_two[1])
  end

  def index(cluster_id)
    distances[0].index {|cluster| cluster && cluster.id == cluster_id}
  end

  def clusters
    distances[0][1..-1]
  end

  def length
    distances.length
  end

  def pretty_print
    distances.each do |ary|
      print "  ["
      ary.each do |distance|
        if distance.nil?
          printf "%9s", "nil"
        elsif distance.is_a?(Cluster)
          printf "%9s", "(#{distance.id}, #{distance.size})"
        else
          printf "%9d", distance
        end
      end
      puts "]"
    end
  end

  private

  def fill_distances(people)
    people.each do |person|
      people.each do |other_person|
        self[person, other_person] = person - other_person
      end
    end
  end
end
