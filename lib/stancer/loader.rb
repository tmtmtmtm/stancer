class Stancer::SourceLoader

  require 'json'
  require 'open-uri' 
  # TODO switch based on an option
  # require 'open-uri/cached'

  def initialize(source)
    @source = source
    @_data = [] unless @source
  end

  # For now we can only read json files, 
  # but can be local files, or URLs (via open-uri)
  def data
    @_data ||= JSON.parse(open(@source).read)
  end
end

