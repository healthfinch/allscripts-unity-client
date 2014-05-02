FactoryGirl.define do
  factory :client_driver, class: AllscriptsUnityClient::ClientDriver do
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
  end
end