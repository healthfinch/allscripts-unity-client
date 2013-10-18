# Allscripts Unity Client

The `allscripts_unity_client` gem is a Ruby client for the Allscripts Unity API.  See http://asdn.unitysandbox.com/UnitySDK/SDK/ for more documentation on the API.
 
## Installation

Add this line to your application's Gemfile:

    gem "allscripts_unity_client"

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install allscripts_unity_client

## Usage

### Creating clients

The Allscripts Unity API has three endpoints: GetSecurityToken, Magic, and RetireSecurityToken and supports both SOAP and JSON.
A Unity API client can be created using the `AllscriptsUnityClient#create` factory:

```ruby
unity_client = AllscriptsUnityClient.create(:base_unity_url => "http://unity.base.url", :appname => "appname", :username => "username", :password => "password")
```

A JSON client can be also be created using the `:mode` option:

```ruby
# Mode defaults to :soap
unity_client = AllscriptsUnityClient.create(:mode => :json, :base_unity_url => "http://unity.base.url", :appname => "appname", :username => "username", :password => "password")
```

### Security token management

The `create` factory will request a security token from Unity when created. The token can be accessed using the `security_token` accessor:

```ruby
unity_client.security_token
unity_client.security_token?
```

Security tokens can be manually requested using the `get_security_token!` method:

```ruby
unity_client.get_security_token! # Fetches a new security token and stores it in security_token
```

Security tokens can be retired using the `retire_security_token!` method:

```ruby
unity_client.retire_security_token! # Retires the security token with Unity and sets security_token to nil
```

After calling `get_security_token!`, each call using `magic` will automatically send `security_token` with the request.

### Executing Magic calls

The endpoint used to make API calls in Unity is called Magic. Magic can be accessed with the client:

```ruby
unity_client.magic({
  :action => "action",
  :userid => "userid",
  :appname => "appname",
  :patientid => "patientid",
  :token => "token",
  :parameter1 => "parameter1",
  :parameter2 => "parameter2",
  :parameter3 => "parameter3",
  :parameter4 => "parameter4",
  :parameter5 => "parameter5",
  :parameter6 => "parameter6",
  :data => "data"
})
```

All keys in the hash given to magic are optional. See the Allscripts Unity API documentation for more information
about which API calls are supported

### Magic call helpers

A number of helper methods exist that abstract away the details of the Magic operation:

 - `get_changed_patients(since = nil)`
 - `get_chart_item_details(userid, patientid, section)`
 - `get_clinical_summary(userid, patientid)`
 - `get_dictionary(dictionary_name, userid = nil, site = nil)`
 - `get_encounter_list(userid, patientid, encounter_type, when_param = nil, nostradamus = nil, show_past_flag = nil, billing_provider_user_name = nil)`
 - `get_medication_by_trans_id(userid, patientid, transaction_id)`
 - `get_patient(userid, patientid, includepix = nil)`
 - `get_patient_activity(userid, patientid)`
 - `get_patient_problems(patientid, show_by_encounter_flag = nil, assessed = nil, encounter_id = nil, medcin_id = nil)`
 - `get_patients_by_icd9(icd9, start = nil, end_param = nil)`
 - `get_provider(provider_id = nil, user_name = nil)`
 - `get_providers(security_filter = nil, name_filter = nil)`
 - `get_server_info`
 - `get_task(userid, transaction_id)`
 - `get_task_list(userid = nil, since = nil)`
 - `save_rx(userid, patientid, rxxml)`
 - `save_task(userid, patientid, task_type = nil, target_user = nil, work_object_id = nil, comments = nil)`
 - `save_task_status(userid, transaction_id = nil, param = nil, delegate_id = nil, comment = nil)`
 - `search_meds(userid, patientid, search = nil)`

All magic helper methods not on this list currently raise `NotImplementedError`. More helper methods will be added in future releases. Pull requests welcome.

## Timezone

All times and dates coming from Unity are in local timezones. When creating the client, the `:timezone` option can be used to configure
automatic timezone conversion. If no `:timezone` is given, then it will default to `UTC`. Timezones must be given in `TZInfo` zone identifier
format. See [TZInfo](http://tzinfo.github.io/) for more information:

```ruby
unity_client = AllscriptsUnityClient.create(:timezone => "America/New_York", :base_unity_url => "http://unity.base.url", :appname => "appname", :username => "username", :password => "password")
```

Any `magic` action that takes in a date needs to be given in UTC. Dates can be `Date`, `DateTime`, `Time`, or a string. Dates will be processed and formatted in the correct
[ISO8601](http://en.wikipedia.org/wiki/ISO_8601) format that Unity requires.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Additional Information

Maintainer(s):  Ash Gupta (https://github.com/incomethax), Neil Goodman (https://github.com/posco2k8)

## License:

Copyright (c) 2012 healthfinch, Inc

MIT License

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.