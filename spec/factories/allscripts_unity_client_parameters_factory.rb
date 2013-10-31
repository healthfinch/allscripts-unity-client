FactoryGirl.define do
  factory :allscripts_unity_client_parameters, :class => Hash do
    initialize_with { attributes }

    base_unity_url "http://www.example.com"
    username Faker::Name.name
    password Faker::Internet.password
    appname Faker::Name.name
    mode [:json, :soap].sample
    log false
    logger nil
  end
end