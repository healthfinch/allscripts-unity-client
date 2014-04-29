require 'pathname'
require 'simplecov'
require 'coveralls'

# Configure coverage stats.
SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  SimpleCov::Formatter::HTMLFormatter,
  Coveralls::SimpleCov::Formatter
]
SimpleCov.start do
  add_filter do |source_file|
    filename = Pathname.new(source_file.filename).basename
    ignored_files = %w(version.rb allscripts_unity_client.gemspec Gemfile Rakefile)

    ignored_files.include?(filename) || source_file.filename.include?('spec/')
  end
end

lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'allscripts_unity_client'

require 'rspec'
require 'webmock/rspec'
require 'savon/mock/spec_helper'
require 'securerandom'
require 'faker'
require 'factory_girl'
require 'json'

# Include all support files
Dir['./spec/support/**/*.rb'].sort.each { |f| require f }

# Include all factories
FactoryGirl.find_definitions

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
end