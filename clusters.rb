#!/usr/bin/env bundle exec ruby

Bundler.require

require 'active_support/core_ext/array'
require_relative "lib/distances"
require_relative "lib/finder"

# 1. Put every individual into a separate cluster
# 2. Find the closest pair of clusters that aren't full
# 3. Merge them into a new cluster (removing the old clusters)
# 4. Mark all the people as being in the new cluster
# 5. If the new cluster is size 10, it is full
# 6. Repeat

filename         = ARGV.shift || "people.json"
Cluster.max_size = (ARGV.shift || 10).to_i

people    = Person.load_all(filename)
distances = Distances.new(people)
finder    = Finder.new(distances, verbose: true)
clusters  = finder.clusters

File.open("results.txt", "w") do |f|
  clusters.each_with_index do |cluster, index|
    f.puts "Table #{index}, size #{cluster.size}:"
    cluster.people.in_groups_of(4).each do |group|
      group.compact!
      f.printf(group.map {|_| "%25s"}.join(" "),
               *group.map(&:name))
      f.puts
    end
    f.puts
  end
end

clusters.each_with_index do |cluster, index|
  puts "Table #{index}, size #{cluster.size}:"
  cluster.people.in_groups_of(4).each do |group|
    group.compact!
    printf(group.map {|_| "%25s"}.join(" "),
           *group.map(&:name))
    puts
  end
  puts
end

