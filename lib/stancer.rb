require "stancer/version"
require 'colorize'

class Stancer
  
  def initialize(h)
    @sources = h[:sources]
  end

  def all_issues
    @_issues = issues_injected_with_indicators
  end

  private
  def source(type)
    @sources[type] or raise "No source for #{type}"
  end

  def source_data(type)
    (@_data ||= {})[type] ||= SourceLoader.new(source(type)).data
  end

  def issues_injected_with_indicators
    issues = source_data(:issues)
    indicators = source_data(:indicators)
    issues.each { |iss| iss['indicators'] ||= indicators.find { |ind| iss['id'] == ind['issue'] }['indicators'] }
    issues
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
