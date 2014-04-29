FactoryGirl.define do
  factory :client_driver, class: AllscriptsUnityClient::ClientDriver do
    initialize_with { new(base_unity_url: base_unity_url, username: username, password: password, appname: appname, proxy: proxy, timezone: timezone, logger: logger) }

    base_unity_url 'http://www.example.com'
    username Faker::Name.name
    password Faker::Internet.password
    appname Faker::Name.name
    proxy nil
    timezone 'America/Phoenix'
    logger nil
  end
end