module TTVDB::Parser
  MAP = {
    "id" => { :map => true, :cast => :integer },
    "combined_episodenumber" => { :map => true, :cast => :float },
    "combined_season" => { :map => true, :cast => :integer },
    "dvd_chapter" => { :map => true, :cast => :integer },
    "dvd_discid" => { :map => true, :cast => :integer },
    "dvd_episodenumber" => { :map => true, :cast => :float },
    "dvd_season" => { :map => true, :cast => :integer },
    "director" => { :map => true, :cast => :array },
    "epimgflag" => { :map => true, :cast => :integer },
    "episodename" => { :map => :name },
    "episodenumber" => { :map => :number, :cast => :integer },
    "firstaired" => { :map => :first_aired, :cast => :time },
    "gueststars" => { :map => :guest_stars, :cast => :array },
    "imdb_id" => { :map => true },
    "language" => { :map => true },
    "overview" => { :map => true },
    "productioncode" => { :map => :production_code },
    "rating" => { :map => true, :cast => :float },
    "ratingcount" => { :map => :rating_count, :cast => :integer },
    "seasonnumber" => { :map => :season_number, :cast => :integer },
    "writer" => { :map => true },
    "absolute_number" => { :map => true, :cast => :integer },
    "filename" => { :map => true },
    "lastupdated" => { :map => :last_updated, :cast => :time_at },
    "seasonid" => { :map => :season_id, :cast => :integer },
    "seriesid" => { :map => :series_id, :cast => :integer },
    "thumb_added" => { :map => true },
    "thumb_height" => { :map => true, :cast => :integer },
    "thumb_width" => { :map => true, :cast => :integer },
    "actors" => { :map => true, :cast => :array },
    "airs_dayofweek" => { :map => true },
    "airs_time" => { :map => true },
    "contentrating" => { :map => :content_rating, :cast => :float },
    "genre" => { :map => true, :cast => :array },
    "network" => { :map => true },
    "networkid" => { :map => :network_id },
    "runtime" => { :map => true, :cast => :integer },
    "seriesname" => { :map => :name },
    "status" => { :map => true },
    "added" => { :map => true },
    "added_by" => { :map => true },
    "banner" => { :map => true },
    "fanart" => { :map => true },
    "poster" => { :map => true },
    "zap2it_id" => { :map => true }
  }

  def parse
    raise "no data to parse" unless @data
    @data.each do |k, v|
      k = k.downcase
      v = v[0]
      unless MAP.include? k
        next
      end
      var = nil
      if MAP[k][:map].is_a? TrueClass
        var = k.to_sym
      else
        var = MAP[k][:map].to_sym
      end

      unless respond_to? var
        next
      end
      k, v = map k, v
      instance_variable_set("@#{k}", v)
    end
    @data = nil
  end

  private
  def map k, v
    case MAP[k][:cast]
      when :integer
        v = v.to_i rescue v
      when :float
        v = v.to_f rescue v
      when :array
        v = v.split("|").compact.reject { |c| c.empty? } rescue v
      when :time_at
        v = Time.at(v.to_i) rescue v
      when :time
        v = Time.parse(v) rescue v
      else
        v = v
    end
    if MAP[k][:map].is_a? TrueClass
      k = k.to_sym
    else
      k = MAP[k][:map].to_sym
    end
    v = (v.is_a? Hash and v.empty?) ? nil : v
    [k, v]
  end
end
