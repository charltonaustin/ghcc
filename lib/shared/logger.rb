require 'logger'

def get_logger(level = Logger::DEBUG)
  logger = Logger.new(STDOUT)
  logger.level = level
  logger
end