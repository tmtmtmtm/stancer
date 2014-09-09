require "stancer/version"
require "stancer/loader"
require 'colorize'

class Stancer
  
  def initialize(h)
    @sources = h[:sources]
  end

  def all_issues
    @_issues = issues_with_embedded_data
  end

  private
  def source(type)
    @sources[type] or raise "No source for #{type}"
  end

  def source_data(type)
    (@_data ||= {})[type] ||= SourceLoader.new(source(type)).data
  end

  def issues_with_embedded_data
    issues     = source_data(:issues)
    indicators = source_data(:indicators)
    motions    = source_data(:motions)  
    votes      = source_data(:votes)  

    issues.each do |iss|
      iss['indicators'] ||= indicators.find { |ind| iss['id'] == ind['issue'] }['indicators'] 
      iss['indicators'].each do |ind|
        ind['motion'] ||= motions.find { |m| m['id'] == ind['motion_id'] } || { 'id' => ind['motion_id'] }
        ind['motion']['vote_events'] ||= [{
          "votes" => [votes.find { |v| v['motion_id'] == ind['motion']['id'] }]
        }]
      end
    end
    return issues
  end

end
