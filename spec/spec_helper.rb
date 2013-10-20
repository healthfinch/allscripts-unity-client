lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'rspec'
require 'allscripts_unity_client'

RSpec.configure do |config|
end