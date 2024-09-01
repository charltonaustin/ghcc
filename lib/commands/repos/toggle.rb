# frozen_string_literal: true

require_relative 'repository'

def toggle_repo(db, logger, org, name)
  Repos.toggle_to_process(db, logger, org, name)
end
