# frozen_string_literal: true

require 'logger'

def get_level_from_options(options)
  if options.key? :v
    Logger::DEBUG
  else
    Logger::ERROR
  end
end

def get_logger(options = {})
  logger = Logger.new($stdout)
  logger.level = get_level_from_options(options)
  logger
end
