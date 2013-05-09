#!/usr/bin/env bundle exec ruby

Bundler.require

require_relative 'lib/distances'

Distances.new.write
