# frozen_string_literal: true

require_relative 'repository'

def toggle_repo(db, logger, org, name)
  toggle_repository_by_(db, logger, org, name)
end
