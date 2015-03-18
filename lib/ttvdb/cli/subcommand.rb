module TTVDB::CLI::Subcommand
  def description d
    doc[:description] = d
  end

  def doc
    @doc ||= {}
  end

  def self.[] index
    @subcmds ||= {}
    return @subcmds[index] if @subcmds[index]
    classname = "TTVDB::CLI::Subcommand::#{index.to_s.capitalize}"
    begin
      klass = eval(classname)
      @subcmds[index] = klass.new
    rescue NameError
      raise RuntimeError, "Unknown subcommand #{index}, See ttvdb --help"
    end
  end
  def self.subcommands
    @subcommands ||= self.load_subcommands
  end

  private
  def self.load_subcommands
    spec = Gem::Specification.find_by_name("ttvdb")
    gem_root = spec.gem_dir
    Dir["#{gem_root}/lib/ttvdb/cli/subcommand/*.rb"].each do |file|
      TTVDB.logger.debug "Loading subcommand file #{file}"
      load file
    end
    @subcommands = TTVDB::CLI::Subcommand.constants.select { |c| TTVDB::CLI::Subcommand.const_get(c).is_a? Class }
  end
end
