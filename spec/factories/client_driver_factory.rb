FactoryGirl.define do
  factory :client_driver, :class => AllscriptsUnityClient::ClientDriver do
    initialize_with { new(base_unity_url, username, password, appname, proxy, timezone) }

    base_unity_url "http://www.example.com"
    username Faker::Name.name
    password Faker::Internet.password
    appname Faker::Name.name
    proxy nil
    timezone "America/Phoenix"
  end
end