# frozen_string_literal: true

require 'logger'

def get_logger(level = Logger::DEBUG)
  logger = Logger.new($stdout)
  logger.level = level
  logger
end
