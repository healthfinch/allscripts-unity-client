FactoryGirl.define do
  factory :client_driver, :class => AllscriptsUnityClient::ClientDriver do
    initialize_with { new(base_unity_url, username, password, appname, proxy, timezone, logger, log) }

    base_unity_url "http://www.example.com"
    username Faker::Name.name
    password Faker::Internet.password
    appname Faker::Name.name
    proxy nil
    timezone "America/Phoenix"
    logger nil
    log false
  end
end