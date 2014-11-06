require "stancer/version"
require "stancer/loader"
require "stancer/stance"
require 'colorize'

class Stancer
  
  def initialize(h)
    @sources = h[:sources]
  end

  def all_stances(opts)
    group = opts[:group_by] or raise "No group_by"
    all_issues.map { |i| 
      i['stances'] = issue_stance(i, group).to_h
      [opts[:exclude]].flatten.each { |k| i.delete(k) }
      i
    }
  end

  def issue_stance(i, group='voter')
    Stance.new(i, group)
  end

  def all_issues
    @_issues = issues_with_embedded_data
  end

  private
  def source(type)
    @sources[type] 
  end

  def source_data(type)
    (@_data ||= {})[type] ||= SourceLoader.new(source(type)).data
  end

  def issues_with_embedded_data
    issues     = source_data(:issues) or raise "Need a source of isses"
    indicators = source_data(:indicators) || []
    motions    = source_data(:motions) || []
    votes      = source_data(:votes) || []

    issues.each do |iss|
      iss['indicators'] ||= (indicators.find { |ind| iss['id'] == ind['issue_id'] } or raise "No indicators for #{iss['id']}")['indicators'] 
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
