class TTVDB::Series
  include TTVDB::Parser
  include TTVDB::Match

  attr_reader :id, :actors, :airs_dayofweek, :airs_time,
  :content_rating, :first_aired, :genre, :imdb_id, :language,
  :network, :network_id, :overview, :rating, :rating_count,
  :runtime, :series_id, :series_name, :status, :added, :added_by,
  :banner, :fanart, :last_updated, :poster, :zap2it_id, :seasons,
  :name

  attr_accessor :client

  def initialize(data)
    @data = Hash[data.map { |k, v| [k.downcase, v] }]
    parse
    @seasons = {}
  end

  def episodes
    @episodes ||= fetch_episodes
  end

  private
  def fetch_episodes
    raise Exception, "client not configured" unless @client
    @episodes = @client.get_episodes_by_series_id @id
    return unless @episodes
    @episodes.each do |episode|
      unless @seasons[episode.combined_season]
        @seasons[episode.combined_season] = {}
      end
      @seasons[episode.combined_season][episode.number] = episode
    end
    sort_episodes!
  end

  def sort_episodes!
    special = []
    sorted = {}
    @seasons.each do |season, data|
      data.each do |n, e|
        if season == 0
          special << e
        else
          sorted[season] ||= []
          sorted[season] << e
        end
      end
    end
    sorted = Hash[sorted.sort_by {|k,v| k.to_i }]
    new_episodes = []
    sorted.each do |season, episodes|
      new_episodes << episodes
    end
    new_episodes << special # specials at the end
    @episodes = new_episodes.flatten.compact
  end
end
