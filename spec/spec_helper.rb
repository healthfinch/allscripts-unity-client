require 'pathname'
require 'simplecov'
SimpleCov.start do
  add_filter do |source_file|
    filename = Pathname.new(source_file.filename).basename
    ignored_files = [
      "version.rb",
      "allscripts_unity_client.gemspec",
      "Gemfile",
      "Rakefile"
    ]

    ignored_files.include?(filename) || source_file.filename.include?("spec/")
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

# Include all factories
FactoryGirl.find_definitions

# Include all support files
Dir["./spec/support/**/*.rb"].sort.each { |f| require f }

RSpec.configure do |config|
end