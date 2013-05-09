#!/usr/bin/env bundle exec ruby

Bundler.require

# clusters = distances with cluster size and cluster id
#
# Put every individual into a separate cluster
# Find the closest pair of clusters where one cluster is size 1 and the other is not full
# Merge them into a new cluster (removing the old clusters)
# Mark all the people as being in the new cluster
# If the new cluster is size 10, it is full
# Repeat


