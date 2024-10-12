# frozen_string_literal: true

require 'thor'
require_relative 'utils'
module Dev
  class Command < Thor
    desc 'install', 'Symlinks ghcc to /usr/local/bin'

    def install
      create_db_file
      ghcc_path = File.expand_path("#{__FILE__}/../../../../ghcc")
      File.symlink(ghcc_path, "/usr/local/bin/#{File.basename(ghcc_path)}")
    end

    desc 'run_migrations', 'Updates current data model'

    def run_migrations
      create_db_file
      Sequel.extension :migration
      get_connection do |db|
        Sequel::Migrator.run(db, File.expand_path("#{__dir__}/../../migrations"))
      end
    end
  end
end
