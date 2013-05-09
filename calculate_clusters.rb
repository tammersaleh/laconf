#!/usr/bin/env bundle exec ruby

Bundler.require

require_relative "lib/distances"

# Put every individual into a separate cluster
# Find the closest pair of clusters that aren't full
# Merge them into a new cluster (removing the old clusters)
# Mark all the people as being in the new cluster
# If the new cluster is size 10, it is full
# Repeat

distances = Distances.new

def find_minimum(distances)
  infinity = 1.0/0
  current_minimum = [infinity, 0, 0]

  distances.each_with_clusters do |distance, cluster1, cluster2|
    next unless cluster1.mergable_with?(cluster2)
    if distance < current_minimum[0]
      current_minimum = [distance, cluster1.id, cluster2.id]
    end
  end

  return current_minimum
end

def find_maximum(distances)
  current_minimum = [0, 0, 0]

  distances.each_with_clusters do |distance, cluster1, cluster2|
    next unless cluster1.mergable_with?(cluster2)
    if distance > current_minimum[0]
      current_minimum = [distance, cluster1.id, cluster2.id]
    end
  end

  return current_minimum
end

until distances.only_one_empty_cluster_left?
  result = find_minimum(distances)
  # result = find_maximum(distances)
  # distances.pretty_print
  # puts "Current Min: #{result[1]},#{result[2]} has distance #{result[0]}"
  # puts "Merging clusters #{result[1, 2]}"
  # puts
  distances.merge_clusters!(*result[1, 2])
end
# distances.pretty_print
# puts

distances.clusters.each do |cluster|
  puts "Cluster #{cluster.id}:"
  cluster.people.each do |person|
    puts "  #{person}"
  end
end
