require "rest-client"
require "logger"
require "xmlsimple"
require "ttvdb/version"
require "ttvdb/client"


module TTVDB
  def self.logger
    @logger ||= Logger.new(STDOUT)
  end
end
