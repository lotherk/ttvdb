class TTVDB::Episode
  attr_reader :id, :number, :name, :overview, :season_id, :series_id,
  :combined_number, :combined_season

  attr_writer :client, :series

  def initialize(data, options={})
    options.merge! data
    @id = options["id"][0].to_i rescue nil
    @number = options["EpisodeNumber"][0].to_i rescue nil
    @name = options["EpisodeName"][0] rescue nil
    @overview = options["Overview"][0] rescue nil
    @season_id = options["seasonid"][0].to_i rescue nil
    @series_id = options["seriesid"][0].to_i rescue nil
    @combined_number = options["Combined_episodenumber"][0].to_i rescue nil
    @combined_season = options["Combined_season"][0].to_i rescue nil
    @client = options[:client] rescue nil
    @series = options[:series] rescue nil
  end

end
