FactoryGirl.define do
  factory :client_options, class: AllscriptsUnityClient::ClientOptions do
    initialize_with { new(attributes) }

    base_unity_url 'http://www.example.com'
    username Faker::Name.name
    password Faker::Internet.password
    appname Faker::Name.name
    proxy nil
    timezone 'America/Phoenix'
    logger nil
    ca_file nil
    ca_path nil
    timeout nil
    new_relic nil
  end
end