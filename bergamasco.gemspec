require "date"
require File.expand_path("../lib/bergamasco/version", __FILE__)

Gem::Specification.new do |s|
  s.authors       = "Martin Fenner"
  s.email         = "mfenner@datacite.org"
  s.name          = "bergamasco"
  s.homepage      = "https://github.com/datacite/bergamasco"
  s.summary       = "Text utilities for working with scholarly metadata"
  s.date          = Date.today
  s.description   = "Text utilities for common cleanup and reformatting tasks when working with scholarly metadata"
  s.require_paths = ["lib"]
  s.version       = Bergamasco::VERSION
  s.extra_rdoc_files = ["README.md"]
  s.license       = 'MIT'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_paths = ["lib"]

  s.add_dependency 'nokogiri', '~> 1.6.7'
  s.add_dependency 'loofah', '~> 2.0', '>= 2.0.3'
  s.add_dependency 'pandoc-ruby', '~> 2.0', '>= 2.0.0'
  s.add_dependency 'builder', '~> 3.2', '>= 3.2.2'
  s.add_dependency 'multi_json', '~> 1.11.2'
  s.add_dependency 'oj', ' ~> 2.18', '>= 2.18.1'
  s.add_dependency 'activesupport', '~> 4.2', '>= 4.2.5'
  s.add_dependency 'safe_yaml', '~> 1.0', '>= 1.0.4'
  s.add_dependency 'addressable', ">= 2.3.6"
  s.add_development_dependency 'bundler', '~> 1.0'
  s.add_development_dependency 'rspec', '~> 3.4'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'codeclimate-test-reporter', "~> 1.0.0"
  s.add_development_dependency 'simplecov'
end
