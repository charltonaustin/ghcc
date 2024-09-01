# frozen_string_literal: true

module Repos
  def self.get_all(db)
    db['SELECT * from repos'].all
  end

  def self.save(db, org, name)
    db['INSERT INTO repos (organization, name, to_process) VALUES (?, ?, ?)', org, name, true].insert
  end

  def self.toggle_to_process(db, logger, org, name)
    to_process = db['SELECT to_process FROM repos WHERE organization = ? and name = ?', org, name].first[:to_process]
    logger.debug("to_process: #{to_process}")
    db['UPDATE repos SET to_process = ? WHERE organization = ? and name = ?', !to_process, org, name].update
  end
end
