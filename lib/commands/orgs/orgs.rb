# frozen_string_literal: true
require "thor"

class Orgs < Thor

  desc "add", "Add in a new org"

  def add(name)
    puts "Adding in #{name}"
  end
end
