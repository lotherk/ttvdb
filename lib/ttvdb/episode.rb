class TTVDB::Episode
  include TTVDB::Parser

  attr_reader :id, :combined_episodenumber, :combined_season,
  :dvd_chapter, :dvd_discid, :dvd_episodenumber, :dvd_season,
  :director, :ep_img_flag, :episode_name, :name, :episode_number,
  :number, :first_aired, :guest_stars, :imdb_id, :overview,
  :last_updated, :rating, :absolute_number, :season_number,
  :season_id, :series_id

  attr_accessor :client, :series

  def initialize(data)
    @data = Hash[data.map { |k, v| [k.downcase, v] }]
    parse
  end

end
