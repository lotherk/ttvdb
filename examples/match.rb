#!/usr/bin/env ruby
#
# ttvdb match example
#
require "ttvdb"

serie = TTVDB::Client.new.get_series_by_id 77772

filename = "s01e65.galaxy.rangers.avi"
episode = serie.match_episode filename
puts episode.inspect


filename = "galaxy.rangers.65.avi"
episode = serie.match_episode filename
puts episode.inspect


filename = "heartbeat.avi"
episode = serie.match_episode filename
puts episode.inspect
