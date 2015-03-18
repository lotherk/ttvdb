require 'ttvdb'
require 'trollop'

module TTVDB::CLI
  def self.options
    @options
  end
  def self.main
    subs = []
    TTVDB::CLI::Subcommand.subcommands.each { |subcmd| subs << subcmd.to_s.downcase }
    p = Trollop::Parser.new do
      version TTVDB::VERSION
      banner "ttvdb #{TTVDB::VERSION}"
      banner ""
      banner "usage: ttvdb [global options] <subcommand> [subcommand options]"
      banner ""
      banner "Available subcommands:"
      TTVDB::CLI::Subcommand.subcommands.each do |subcmd|
        subcmd = subcmd.downcase
        len = 16
        diff = len - subcmd.length
        inst = TTVDB::CLI::Subcommand[subcmd]
        desc = TTVDB::CLI::Subcommand[subcmd].description rescue nil
        banner "  %s%#{diff}s - %s" % [subcmd, "", desc]
      end
      banner ""
      banner "Global options:"
      opt :language, "Language", :default => "en", :short => '-l'
      opt :debug, "Enable debug messages", :default => false, :short => '-d'
      stop_on subs
    end
    @options = Trollop::with_standard_exception_handling p do
      raise Trollop::HelpNeeded if ARGV.empty?
      p.parse
    end
    subcmd = ARGV.shift
    client = TTVDB::Client.new(:language => @options[:language])
    begin
      TTVDB::CLI::Subcommand[subcmd].main client
    rescue RuntimeError => e
      unless @options[:debug]
        puts "Error: #{e.message}"
        exit 1
      else
        raise
      end
    rescue
      raise
    end

  end
end

require 'ttvdb/cli/subcommand'
