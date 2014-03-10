class TTVDB::Season
  attr_reader :episodes, :series, :number
  def initialize series, numer
    @episodes = {}
    @series = series
    @number
  end

  def add_episode episode
    @episodes[episode.number] = episode
  end
end
