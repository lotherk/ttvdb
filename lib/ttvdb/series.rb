class TTVDB::Series
  attr_reader :id, :actors, :airs_dayofweek, :airs_time,
  :content_rating, :first_aired, :genre, :imdb_id, :language,
  :network, :network_id, :overview, :rating, :rating_count,
  :runtime, :series_id, :series_name, :status, :added, :added_by,
  :banner, :fanart, :last_updated, :poster, :zap2it_id, :episodes, :seasons,
  :name

  attr_writer :client

  def initialize(data, options={})
    options.merge! data
    @id = options["id"][0].to_i rescue nil
    @actors = options["Actors"][0].split("|").compact rescue []
    @airs_dayofweek = options["Airs_DayOfWeek"][0] rescue nil
    @airs_time = options["Airs_Time"][0] rescue nil
    @content_rating = options["ContentRating"][0].to_f rescue 0
    @first_aired = Time.parse(options["FirstAired"][0]) rescue nil
    @genre = options["Genre"][0].split("|").compact rescue []
    @imdb_id = options["IMDB_ID"][0].to_i rescue nil
    @language = options["language"][0] rescue nil
    @language ||= options["Language"][0] rescue "en"
    @network = options["Network"][0] rescue nil
    @network_id = options["NetworkID"][0] rescue nil
    @overview = options["Overview"][0] rescue nil
    @rating = options["Rating"][0].to_f rescue 0
    @rating_count = options["RatingCount"][0] rescue 0
    @runtime = options["Runtime"][0].to_i rescue nil
    @runtime ||= options["runtime"][0].to_i rescue 0
    @series_id = options["SeriesID"][0].to_i rescue nil
    @series_name = options["SeriesName"][0] rescue nil
    @name = @series_name
    @status = options["Status"][0].downcase rescue nil
    @added = options["added"][0] rescue nil
    @added_by = options["addedBy"][0] rescue nil
    @banner = options["banner"][0] rescue nil
    @fanart = options["fanart"][0] rescue nil
    @last_updated = Time.at(options["lastupdated"][0].to_i) rescue nil
    @poster = options["poster"][0] rescue nil
    @zap2it_id = options["zap2it_id"][0] rescue nil
    @client = options[:client] rescue nil
    @seasons = {}
    TTVDB.logger.debug { "Series language: #{@language}" }
    fetch_episodes
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
