# frozen_string_literal: true
$:.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'europeana/logging/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'europeana-logging'
  s.version     = Europeana::Logging::VERSION
  s.authors     = ['Richard Doe']
  s.email       = ['richard.doe@rwdit.net']
  s.homepage    = 'https://github.com/europeana/europeana-logging-ruby'
  s.summary     = 'Europeana logging'
  s.description = 'Common logging configuration for Europeana Ruby applications'
  s.license     = 'EUPL-1.1'

  s.required_ruby_version = '>= 2.0.0'

  s.files = Dir['{app,lib}/**/*', 'LICENSE.md', 'Rakefile', 'README.md']
  s.test_files = Dir['test/**/*']

  s.add_dependency 'rails', '~> 4.2'

  s.add_dependency 'lograge', '~> 0.4'
  s.add_dependency 'logstash-event', '~> 1.2'
  s.add_dependency 'logstash-logger', '~> 0.19'
end
