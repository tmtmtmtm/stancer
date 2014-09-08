require "stancer/version"
require 'colorize'

class Stancer
  
  def initialize(h)
    @sources = h[:sources]
  end

  def source_data(type)
    @_data ||= SourceLoader.new(source(type)).data
  end

  private
  def source(type)
    @sources[type] or raise "No source for #{type}"
  end


  class SourceLoader

    require 'json'

    def initialize(source)
      @source = source
    end

    # For now we can only read json files
    def data
      @_data ||= JSON.parse(open(@source).read)
    end
  end

end
