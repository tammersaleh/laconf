#!/usr/bin/env bundle exec ruby

Bundler.require

require_relative "lib/distances"

# Put every individual into a separate cluster
# Find the closest pair of clusters where one cluster is size 1 and the other is not full
# Merge them into a new cluster (removing the old clusters)
# Mark all the people as being in the new cluster
# If the new cluster is size 10, it is full
# Repeat


Infinity = 1.0/0
current_minimum = [Infinity, 0, 0]

Distances.new.each_with_index do |distance, i, j|
  if distance < current_minimum[0]
    current_minimum = [distance, i, j]
  end
end

p current_minimum
