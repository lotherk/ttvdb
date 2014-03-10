#!/usr/bin/env ruby
require "ttvdb"

TTVDB.logger.level = Logger::WARN

client = TTVDB::Client.new
series = nil

if ARGV[0].to_i > 0
  series = [client.get_series_by_id(ARGV[0].to_i)]
else
  series = client.get_series ARGV[0]
end

series.each do |serie|
  puts serie.name
  puts "Overview:"
  puts serie.overview

  puts ""
  serie.seasons.each do |season, episodes|
    puts "Season: %02d" % season
    episodes.each do |number, episode|
      puts "  #%02d - %s" % [number, episode.name]
    end
  end
end
