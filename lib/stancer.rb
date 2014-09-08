require "stancer/version"

class Stancer
  
  def initialize(h)
    @sources = h[:sources]
  end

  def source(type)
    @sources[type]
  end

end
