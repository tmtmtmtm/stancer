
class Stancer::SourceLoader

  require 'json'

  def initialize(source)
    @source = source
    @_data = [] unless @source
  end

  # For now we can only read json files
  def data
    @_data ||= JSON.parse(open(@source).read)
  end
end

