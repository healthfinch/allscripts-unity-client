lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require "allscripts_unity_client/version"
require "date"

Gem::Specification.new do |gem|
  gem.name                  = "allscripts_unity_client"
  gem.version               = AllscriptsUnityClient::VERSION
  gem.date                  = Date.today
  gem.required_ruby_version = "> 1.9.3"
  gem.license               = "MIT"
  gem.homepage              = "https://github.com/healthfinch/allscripts-unity-client"

  gem.summary     = "Allscripts Unity API client"
  gem.description = "Provides a simple interface to the Allscripts Unity API using JSON or SOAP. Developed at healthfinch, Inc. http://healthfinch.com"

  gem.authors = ["Ash Gupta", "Neil Goodman"]
  gem.email   = ["ash.gupta@healthfinch.com", "neil@healthfinch.com"]

  gem.require_paths = ["lib"]

  gem.files = `git ls-files`.split("\n")

  gem.add_runtime_dependency "savon", "~> 2.3.0"
  gem.add_runtime_dependency "httpi", "~> 2.1.0"
  gem.add_runtime_dependency "net-http-persistent", "~> 2.9.0"
  gem.add_runtime_dependency "tzinfo", "~> 0.3.29"
  gem.add_runtime_dependency "nokogiri", "< 1.6", ">= 1.4.0"
  gem.add_runtime_dependency "nori", "~> 2.3.0"
  gem.add_runtime_dependency "american_date", "~> 1.1.0"

  gem.add_development_dependency "factory_girl", "~> 4.2.0"
  gem.add_development_dependency "rake", "~> 10.1.0"
  gem.add_development_dependency "faker", "~> 1.2.0"
  gem.add_development_dependency "rspec", "~> 2.14.1"
  gem.add_development_dependency "simplecov", "~> 0.7.1"
  gem.add_development_dependency "webmock", "~> 1.15.0"
  gem.add_development_dependency "coveralls", "~> 0.7.0"
end
