#!/usr/bin/env bundle exec ruby

Bundler.require

require_relative 'lib/person'

class Survey
  def initialize
    @wufoo = WuParty.new("tammersaleh", ENV["WUFOO_API_KEY"])
    @form = @wufoo.form("la-conf-lunch-questions")
  end

  def entries
    @entries ||= normalize_entries
  end

  def count
    entries.length
  end

  def write_people
    Person.write(entries)
  end

  private

  def normalize_entries
    all_entries.map do |entry|
      puts entry["Field22"]
      {
        id:        entry["EntryId"].to_i,
        name:      entry["Field22"],
        age:       entry["Field2"].to_i,
        countries: entry["Field6"].to_i,
        testing:   entry["Field1"],
        drink:     entry["Field4"],
        lang:      entry["Field5"],
        eat:       entry["Field19"],
        fun:       entry["Field20"],
        guns:      entry["Field21"]
      }
    end
  end

  def all_entries
    one   = @form.entries(limit: 100)
    two   = @form.entries(limit: 100, offset: 100)
    three = @form.entries(limit: 100, offset: 200)
    one + two + three
  end
end

survey = Survey.new

survey.write_people
puts "Downloaded #{survey.count} entries"
