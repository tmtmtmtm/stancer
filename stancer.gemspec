# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'stancer/version'

Gem::Specification.new do |spec|
  spec.name          = "stancer"
  spec.version       = Stancer::VERSION
  spec.authors       = ["Tony Bowden"]
  spec.email         = ["tony@tmtm.com"]
  spec.summary       = %q{Generate stances from legislative voting records.}
  spec.description   = %q{Turn voting records from "Voted Yes on Motion 2013-44b-iii and No on 2014-193-f2" into "voted in favour of increased government transparency".}
  spec.homepage      = "http://discomposer.com/stancer/"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency     "json"
  spec.add_runtime_dependency     "colorize"
  spec.add_runtime_dependency     "open-uri-cached"

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "minitest"
end
