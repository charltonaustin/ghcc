# frozen_string_literal: true

def list_repos_from(db)
  db['SELECT * from repos'].all
end

def add_repo_with(db, org, name)
  db['INSERT INTO repos (organization, name, to_process) VALUES (?, ?, ?)', org, name, true].insert
end

def toggle_repository_by_(db, logger, org, name)
  to_process = db['SELECT to_process FROM repos WHERE organization = ? and name = ?', org, name].first[:to_process]
  logger.debug("to_process: #{to_process}")
  db['UPDATE repos SET to_process = ? WHERE organization = ? and name = ?', !to_process, org, name].update
end
