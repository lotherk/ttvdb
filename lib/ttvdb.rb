require "rest-client"
require "logger"
require "xmlsimple"
require "ttvdb/version"
require "ttvdb/match"
require "ttvdb/client"


module TTVDB
  def self.logger(output=STDOUT)
    unless @logger
      @logger = Logger.new(output)
      @logger.formatter = proc { |severity, datetime, progname, msg|
        kaller = caller[4]
        file, ln, func  = kaller.split(":")
        _nil, func = func.split("`")
        func.gsub!(/[<>']/, "")
        file = File.basename(file)
        "#{datetime} #{severity} #{file}:#{func}:#{ln}: #{msg}\n"
      }
      @logger.level = Logger::WARN
    end
    @logger
  end
end
