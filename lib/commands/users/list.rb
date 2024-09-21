# frozen_string_literal: true

require_relative 'repository'
require 'fuzzystringmatch'
module Users
  module List
    def self.list_users_from(db, match, to_process)
      users = Users::Repository.get_users(db)
      users = get_processable_users(users) if to_process
      return print(users) if no_match(match)

      users = add_matched(users)
      string_matcher = FuzzyStringMatch::JaroWinkler.create(:pure)
      users = match_name(string_matcher, match, users)
      users = match_username(string_matcher, match, users)
      print(users)
    end

    def self.add_matched(users)
      users.map do |user|
        user[:matched] = false
        user
      end
    end

    private_class_method def self.print(users)
      users.each do |user|
        puts "Username: #{user[:user_name]}, name: #{user[:name]}, to_process: #{user[:to_process]} "
      end
      nil
    end

    private_class_method def self.matches(jarow, match, value)
      name_match = jarow.getDistance(value, match)
      name_match && (name_match > 0.7)
    end

    private_class_method def self.get_processable_users(users)
      users.select do |user|
        user[:to_process]
      end
    end

    private_class_method def self.no_match(match)
      match.nil? || match.empty?
    end

    private_class_method def self.match_name(jarow, match, users)
      users.select do |user|
        user[:name].nil? || matches(jarow, match, user[:name].downcase) || user[:matched]
      end
      users.map do |user|
        user[:matched] = true
        user
      end
    end

    private_class_method def self.match_username(jarow, match, users)
      users.select do |user|
        matches = matches(jarow, match, user[:user_name].downcase)
        puts "matches #{matches}"
        user[:user_name].nil? || matches || user[:matched]
      end
      users.map do |user|
        user[:matched] = true
        user
      end
    end
  end
end
