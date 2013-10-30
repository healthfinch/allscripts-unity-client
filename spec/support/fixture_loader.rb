require 'yaml'
require 'json'

class FixtureLoader
  def self.load_yaml(filename)
    YAML.load(read(filename))
  end

  def self.load_json(filename)
    JSON.parse(read(filename))
  end

  def self.load_file(filename)
    read(filename)
  end

  private

  def self.read(filename)
    File.read(File.expand_path("../../fixtures/#{filename}", __FILE__))
  end
end