# frozen_string_literal: true

module Users
  module Repository
    def self.save_user_name(db, user_name, name)
      return if db['select count(*) as c from users where user_name = ?', user_name].first[:c].positive?

      db[
        'INSERT INTO users (user_name,name) VALUES (?, ?)',
        user_name, name
      ].insert
    end

    def self.get_users(db)
      db['SELECT * FROM users'].all
    end

    def self.toggle_by_username(db, logger, user_name)
      to_process = db['SELECT to_process FROM users WHERE user_name = ?', user_name].first[:to_process]
      logger.debug("to_process: #{to_process}")
      db['UPDATE users SET to_process = ? WHERE user_name = ?', !to_process, user_name].update
    end

    def self.toggle_by_name(db, logger, name)
      to_process = db['SELECT * FROM users WHERE name = ?', name].first[:to_process]
      logger.debug("to_process: #{to_process}")
      db['UPDATE users SET to_process = ? WHERE name = ?', !to_process, name].update
    end
  end
end
