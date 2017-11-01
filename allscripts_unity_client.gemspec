lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'allscripts_unity_client/version'
require 'date'

Gem::Specification.new do |gem|
  gem.name                  = 'allscripts_unity_client'
  gem.version               = AllscriptsUnityClient::VERSION
  gem.date                  = Date.today
  gem.required_ruby_version = '> 2.0.0'
  gem.license               = 'MIT'
  gem.homepage              = 'https://github.com/healthfinch/allscripts-unity-client'

  gem.summary     = 'Allscripts Unity API client'
  gem.description = 'Provides a simple interface to the Allscripts Unity API using JSON. Developed at healthfinch http://healthfinch.com'

  gem.authors = ['healthfinch']
  gem.email   = %w(darkarts@healthfinch.com)

  gem.require_paths = ['lib']

  gem.files = `git ls-files`.split("\n").delete_if { |file| /^\.ruby-version$/.match(file) }

  gem.add_dependency 'httpclient', '~> 2.6'
  gem.add_dependency 'activesupport', '>=3', '< 5'
  gem.add_dependency 'nokogiri', '>= 1.4.0'
  gem.add_dependency 'nori', '~> 2.4.0'
  gem.add_dependency 'american_date', '~> 1.1.0'
  gem.add_dependency 'multi_json', '~> 1.0'
  gem.add_dependency 'rubyntlm', '~> 0.4.0'

  gem.add_development_dependency 'factory_girl', '~> 4.4.0'
  gem.add_development_dependency 'rake', '~> 10.3.1'
  gem.add_development_dependency 'faker', '~> 1.4.2'
  gem.add_development_dependency 'rspec', '~> 3.0.0'
  gem.add_development_dependency 'webmock', '~> 1.18.0'
  gem.add_development_dependency 'simplecov', '~> 0.7.1'
  gem.add_development_dependency 'rubocop', '~> 0.51'
end
