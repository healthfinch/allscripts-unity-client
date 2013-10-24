FactoryGirl.define do
  factory :echo_magic_request, :parent => :magic_request do
    action "Echo"
    appname nil
    userid Faker::Name.name
    patientid nil
    token nil
  end
end