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
    begin
      hsh = XmlSimple.xml_in(client[lookup].get)
      return TTVDB::Series.new(hsh["Series"][0], :client => self)
    rescue Exception => e
      raise
    end
  end

  def get_series name
    _client = RestClient::Resource.new("#{@opts[:api_url]}/GetSeries.php", :headers  => { :params => { 'seriesname' => name, 'language' => @language }})
    begin
      hsh = XmlSimple.xml_in(_client.get)
      return [] unless hsh["Series"]
      series = []
      hsh["Series"].each do |s|
        serie = TTVDB::Series.new(s, :client => self)
        next if serie.language != @language
        series << serie
      end
      return series
    rescue Exception => e
      TTVDB.logger.error { "Error while fetching series: #{e.message}" }
      raise
    end
  end

  def get_episodes_by_series_id id
    lookup = "series/#{id}/all/#{@language}.xml"
    begin
      hsh = XmlSimple.xml_in(client[lookup].get)
      return [] unless hsh["Episode"]
      episodes = []
      hsh["Episode"].each do |e|
          episodes << TTVDB::Episode.new(e, :client => self)
      end
      return episodes
    rescue Exception => e
      TTVDB.logger.error("get_episodes_by_series_id") { "Could not create hash from result: #{e.message}" }
      raise
    end
  end

  private
  def client
    @client ||= RestClient::Resource.new("#{@opts[:api_url]}/#{@apikey}/")
  end

end
