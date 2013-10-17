# Allscripts Unity Client

The allscripts_unity_client Gem is a ruby wrapper for the Allscripts Unity API.  See http://asdn.unitysandbox.com/UnitySDK/SDK/ for more information regarding the Allscripts API
 
## Installation

Add this line to your application's Gemfile:

    gem 'unityapi'

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install unityapi

## Usage

1.) Initialize the Unity Client

    client = Unityapi::UnityClient.new(unity_username, unity_password, appname, unity_server_url)

If using a proxy server:
    
    client = Unityapi::UnityClient.new(unity_username, unity_password, appname, unity_server_url, proxy_server_url)
    
2.) Make calls with the client

    unity_response = client.magic_action(action_name, provider_username, patient_id, param_1, param_2, param_3, param_4, param_5, param_6)
	patient_data = client.get_patient("jmedici", 77) #shortcut for the GetPatient Unity Call - gets patient 77 for provider with username "jmedici"

3.) Close the connection

	client.close
   
The UnityApi Gem uses Savon as the SOAP client to broker the connection, and does all the setup work for managing the security token for you as you use Unity Calls.

For a full list of supported calls please browse the source found in lib/unityapi/unity_client.rb or use the client.magic_action 

## To Dos

1. Add tests
2. Add documentation
3. Clean up Unity calls for a target born-on date
 
## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Additional Information

Maintainer(s):  Ash Gupta (https://github.com/incomethax), Neil Goodman (https://github.com/posco2k8)

License:
MIT License. Copyright 2012 healthfinch, Inc. http://www.healthfinch.com