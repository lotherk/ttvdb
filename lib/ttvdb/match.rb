require 'similar_text'
module TTVDB::Match
  def match_episode filename, opts = {}
    episode = nil
    case opts[:filter]
      when :sorted
        episode = match_episode_sorted filename, opts
      when :name
        episode = match_episode_name filename, opts
      when :regex
        episode = match_episode_regex filename, opts
      else
        # try all
        episode = match_episode_regex filename, opts rescue nil
        episode ||= match_episode_name filename, opts rescue nil
        episode ||= match_episode_sorted filename, opts rescue nil
    end
    episode
  end

  private
  def match_episode_sorted filename, opts = {}
    enum = get_episode filename
    return episodes[enum-1] rescue nil
  end

  def match_episode_name filename, opts = {}
    results = []
    episodes.each do |episode|
      min = opts[:min]
      min ||= 60
      results << episode if episode.name.similar(filename) >= min
    end
    if results.count == 0
      results = nil
    elsif results.count == 1
      results = results[0]
    end
    return results
  end

  def match_episode_regex filename, opts = {}
    snum = get_season filename
    enum = get_episode filename
    seasons[snum][enum] rescue nil
  end

  def get_episode filename
    filter_episode = [
      /e(\d+)/i,
      /(\d+)/i
    ]
    filter_episode.each do |r|
      m = filename.match(r)
      if m
        return m[1].to_i rescue nil
      end
    end
  end

  def get_season filename
    filter_season = [
      /s(\d+)/i,
      /season.*(\d+)/i,
      /staffel.*(\d+)/i,
      /(\d+)x/i,
      /(\d+)-/i
    ]
    filter_season.each do |r|
      m = filename.match(r)
      if m
        return m[1].to_i rescue nil
      end
    end
  end
end
