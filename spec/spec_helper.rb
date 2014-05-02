require 'pathname'
require 'simplecov'

# Setup coveralls only if running inside Travis-CI
if ENV['TRAVIS']
  require 'coveralls'
  SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
    SimpleCov::Formatter::HTMLFormatter,
    Coveralls::SimpleCov::Formatter
  ]
end

# Configure coverage stats.
SimpleCov.start do
  ignored_files = %w(version.rb allscripts_unity_client.gemspec Gemfile Rakefile)

  add_filter do |source_file|
    filename = Pathname.new(source_file.filename).basename
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

RSpec.configure do |config|
  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = "random"
end