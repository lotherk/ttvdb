class TTVDB::CLI::Subcommand::Search
  extend TTVDB::CLI::Subcommand
  attr_reader :description
  def initialize
    @description = "search a serie"
  end
  def main client
    p = Trollop::Parser.new do
      banner "Search for a series"
      banner ""
      banner "usage: ttvdb [options] search [options] name1 name2 name3 ..."
      banner ""
      banner "nameN can either be id or name"
      banner ""
      banner "Example:"
      banner ""
      banner "  $ ttvdb search \"Galaxy Rangers\""
      banner ""
      banner "  $ ttvdb search 77772"
      banner ""
      banner "  $ ttvdb search \"Galaxy Rangers\" -d"
      banner ""
      banner "  $ ttvdb search \"Galaxy Rangers\" -d -l 10"
      banner ""
      banner "  $ ttvdb search 77772 -e heartbeat"
      banner ""
      banner "  $ ttvdb search 77772 -e s01e65"
      banner ""
      banner "  $ ttvdb search 77772 -e e65"
      banner ""
      banner "  $ ttvdb search 77772 -e 65"
      banner ""

      banner "Options:"
      opt :detailed, "show detailed informations for a series", :short => "-d"
      opt :limit, "limit result if --detailed is used", :short => "-l", :default => 0
      opt :episode, "show detailed informations for an episode. can be name, num or id", :short => 'e', :type => String
      conflicts :detailed, :episode
    end

    @opts = Trollop::with_standard_exception_handling p do
      raise Trollop::HelpNeeded if ARGV.empty?
      p.parse
    end

    ARGV.each do |term|
      series = []
      if term.to_i > 0
        series = [client.get_series_by_id(term.to_i)]
      else
        series = client.get_series term
      end

      series.each do |serie|
        puts "#{serie.name}, #{serie.id}"

        if @opts[:detailed]
          detailed serie
        end

        if @opts[:episode]
          es = serie.match_episode @opts[:episode]
          es = [es] unless es.is_a? Array
          es.each do |e|
            puts ""
            if es.count > 1
              puts "-" * 20
            end
            puts e.name
            detailed e
          end
        end


      end
    end
  end

  private
  def detailed serie
    skip = ["client", "seasons"]
    serie.instance_variables.each do |var|
      val = serie.instance_variable_get var
      next unless val
      next if val.to_s.empty?
      next if skip.include? var.to_s.gsub(/^@/, "")
      puts "  %s: %s" % [var.to_s.gsub(/^@/, ""), val]
    end
    return unless serie.respond_to? :episodes
    puts ""
    puts "  Episodes: %i total" % [serie.episodes.count]
    serie.seasons.each do |season, episodes|
      puts "    Season: %02d" % season
      limit = @opts[:limit] > 0 ? @opts[:limit] : episodes.keys.count
      episodes.first(limit).each do |num, episode|
        puts "      #%03d - %s (%s)" % [num, episode.name, episode.id]
      end
      if limit < episodes.keys.count
        puts "      ... %i more" % (episodes.keys.count - limit)
      end
    end
  end
end
