# frozen_string_literal: true

require "thor"

class Dev < Thor
  desc "install", "Symlinks this file to /usr/local/bin"
  def install
    File.symlink(File.expand_path(__FILE__), "/usr/local/bin/#{File.basename(__FILE__)}")
  end

  desc "run_migrations", "Updates current data model"
  def run_migrations
    Sequel.extension :migration
    get_connection do |db|
      puts File.expand_path("#{__dir__}/../../migrations")
      Sequel::Migrator.run(db, File.expand_path("#{__dir__}/../../migrations"))
    end
  end
end
