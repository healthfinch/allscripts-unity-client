lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'allscripts_unity_client'
require 'securerandom'
require 'faker'
require 'factory_girl'
require 'rspec'

# Include all factories
FactoryGirl.find_definitions

# Include all support files
Dir["./spec/support/**/*.rb"].sort.each { |f| require f }

RSpec.configure do |config|
end