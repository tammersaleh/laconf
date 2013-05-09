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

finder = Finder.new(Distances.new(Person.all), verbose: true)

finder.clusters.each_with_index do |cluster, index|
  puts "Table #{index}, size #{cluster.size}:"
  cluster.people.in_groups_of(4).each do |group|
    group.compact!
    printf(group.map {|_| "%25s"}.join(" "),
           *group.map(&:name))
    puts
  end
end
puts
