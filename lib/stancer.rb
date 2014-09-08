require "stancer/version"
require 'colorize'

class Stancer
  
  def initialize(h)
    @sources = h[:sources]
  end

  def all_issues
    @_issues = issues_with_embedded_motions
  end

  private
  def source(type)
    @sources[type] or raise "No source for #{type}"
  end

  def source_data(type)
    (@_data ||= {})[type] ||= SourceLoader.new(source(type)).data
  end

  def issues_with_embedded_indicators
    issues = source_data(:issues)
    indicators = source_data(:indicators)
    issues.each do |iss| 
      iss['indicators'] ||= indicators.find { |ind| iss['id'] == ind['issue'] }['indicators'] 
    end
    return issues
  end

  def issues_with_embedded_motions
    issues = issues_with_embedded_indicators
    motions = source_data(:motions)  # or might be included elsewhere...
    issues.each do |iss|
      iss['indicators'].each do |ind|
        ind['motion'] ||= motions.find { |m| 
          # warn "Checking #{m['id']} against #{ind['motion_id']} : #{m['id'] == ind['motion_id']}"
          m['id'] == ind['motion_id'] 
        } 
      end
    end
    return issues
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
