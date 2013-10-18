lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require "allscripts_unity_client/version"
require "date"

Gem::Specification.new do |gem|
  gem.name                  = "allscripts_unity_client"
  gem.version               = AllscriptsUnityClient::VERSION
  gem.date                  = Date.today
  gem.required_ruby_version = "~> 1.9"

  gem.description = "Allscripts Unity Enterprise API client"
  gem.summary     = "This is a ruby wrapper for the Allscripts Unity Enterprise API"

  gem.authors = ["Ash Gupta", "Neil Goodman"]
  gem.email   = ["ash.gupta@healthfinch.com", "neil@healthfinch.com"]

  gem.require_paths = ["lib"]

  gem.files   = `git ls-files`.split("\n")
  gem.license = "MIT"

  gem.add_runtime_dependency "savon", "~> 2.3.0"
  gem.add_runtime_dependency "httpi", "~> 2.1.0"
  gem.add_runtime_dependency "net-http-persistent", "~> 2.9.0"
  gem.add_runtime_dependency "tzinfo", "~> 1.1.0"
  gem.add_runtime_dependency "tzinfo-data", "~> 1.2013.7"
  gem.add_runtime_dependency "nokogiri", ">= 1.4.0", "< 1.6"

  gem.add_development_dependency "rake", "~> 10.1.0"
end
