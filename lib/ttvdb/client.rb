require 'ttvdb/parser'
require 'ttvdb/series'
require 'ttvdb/episode'

class TTVDB::Client
  attr_accessor :language

  def initialize(opts = {})
    @opts = {
      :api_url => 'http://www.thetvdb.com/api/',
      :api_key => '530293E55310DAB2',
      :language => 'en',
    }.merge!opts
    @language = @opts[:language]
    @apikey = @opts[:api_key]
  end

  def get_series_by_id id
    lookup = "series/#{id}/#{@language}.xml"
    hsh = XmlSimple.xml_in(client[lookup].get)
    serie = TTVDB::Series.new(hsh["Series"][0])
    serie.client = self
    return serie
  end

  def get_series name
    _client = RestClient::Resource.new("#{@opts[:api_url]}/GetSeries.php", :headers  => { :params => { 'seriesname' => name, 'language' => @language }})
    hsh = XmlSimple.xml_in(_client.get)
    return [] unless hsh["Series"]
    series = []
    hsh["Series"].each do |s|
      serie = TTVDB::Series.new(s)
      next if serie.language != @language
      serie.client = self
      series << serie
    end
    return series
  end

  def get_episodes_by_series_id id
    lookup = "series/#{id}/all/#{@language}.xml"
    hsh = XmlSimple.xml_in(client[lookup].get)
    return [] unless hsh["Episode"]
    episodes = []
    hsh["Episode"].each do |e|
      episode = TTVDB::Episode.new(e)
      episode.client = self
      episodes << episode
    end
    episodes
  end

  private
  def client
    @client ||= RestClient::Resource.new("#{@opts[:api_url]}/#{@apikey}/")
  end

end
