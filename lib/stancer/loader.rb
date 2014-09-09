
class Stancer::SourceLoader

  require 'json'

  def initialize(source)
    @source = source
  end

  # For now we can only read json files
  def data
    @_data ||= JSON.parse(open(@source).read)
  end
end

