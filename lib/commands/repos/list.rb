# frozen_string_literal: true

require_relative 'repository'

def list_repos(db)
  repos = Repos.get_all(db)
  repos.each do |repo|
    puts repo
  end
end
