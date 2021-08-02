<p align="center">
    <img src="https://user-images.githubusercontent.com/56378698/127357452-1b57af9c-be5a-42ff-aecb-bd2e2c006716.png" alt="Pioneer logo" width="200" height="200">
</p>

# Ruby SDK for Pioneer
[![ruby-javascript-sdk](https://github.com/pioneer-io/ruby-sdk/actions/workflows/verify.yml/badge.svg)](https://github.com/pioneer-io/ruby-sdk/actions/workflows/verify.yml)
![](https://ruby-gem-downloads-badge.herokuapp.com/pioneer_ruby_sdk?color=blue)
[![Gem Version](https://badge.fury.io/rb/pioneer_ruby_sdk.svg)](https://badge.fury.io/rb/pioneer_ruby_sdk)

This module is a server-side SDK for applications written in Ruby using Pioneer's feature management service.

Visit the [Pioneer-io/pioneer](https://github.com/pioneer-io/pioneer) repo for more or check our Pioneer's [case study page](https://pioneer-io.github.io/).

## Getting Started
The Pioneer Ruby SDK is available as a Ruby Gem: https://rubygems.org/gems/pioneer_ruby_sdk

First you need to install the Gem:
```
gem install pioneer_ruby_sdk
```

## Utilising the SDK in application code
Now, you will need to require the `pioneer_ruby_sdk` gem in your application.
To create a new SDK client, the URI of the `scout` daemon is required in addition to an SDK key, obtained from the `Account` tab of the Compass application's user interface. The default port for `scout` is `:3030` and the `/features` endpoint is the proper endpoint to receive flag updates.

The SDK client will receive ruleset updates in real-time via SSE any time a feature flag is created/updated/deleted via the Compass dashboard.
```Ruby
require 'pioneer_ruby_sdk'

sdk_client = PioneerRubySdk.new('/path/to/scout', 'sdk_key')

sdk_connection = sdk_client.connect().with_wait_for_data()
```

## Failed SSE Connections
If the SDK fails to connect to the Scout daemon as an eventsource client, the connection attempt will be retried up to 10 times. The SDK will 'jitter' these connection attempts-- pausing for a random length of time between 1 and 10 seconds (inclusive) in between each attempt.

If the connection fails 10 times, an error will be logged to the user (example below) and the SDK will stop trying to connect.

```text 
Cannot connect to Scout, connection timed out
```
## Usage
### Using without percentage rollout
### `client.get_feature(key, default = nil) -> boolean`
This method will check the current ruleset for a flag by the name of `key` and return the boolean value associated with that flag. 
```Ruby
# assuming there is an existing flag titled 'test this flag' 
# whose active status is set to true
puts sdk_connection.get_feature('test this flag') # -> true

# a basic branch to use a microservice might look like this:
puts 'What service is being called with `test this flag`?'
if sdk_connection.get_feature('test this flag')
	puts 'Calling some microservice...'
	# call to new microservice goes here
else
	puts 'Calling the monolith service...'
	# monolith defined service call goes here
end
```
The default value is used to provide a redundant backup; if the SDK cannot find a flag for the given key and the default value was provided, it will use the default value and log warning notifying you that it had to fall back to the default value.
```Ruby
sdk_connection.get_feature('whoops, no flag', true) 
# -> true
# -> "Warning: Could not get whoops, no flag from features, using provided default value!"
```
### Using the percentage rollout strategy
When a flag has a rollout percentage assigned to it, you can leverage the rollout strategy for that flag by giving the SDK instance a 'context'. This context is created using a unique identifier of your choosing, in string format.
To do so, use a unique identifier, and call the `with_context` method on an existing SDK connection, passing in the identifier to create the context.

The SDK will determine whether the user's context falls within the rollout percentage. This is done by summing the values of the code points within the string argument, and modding by 100 (the maximum rollout percentage possible). If the resulting value is less than or equal to the flag's rollout percentage, `get_feature()` will return `true`, and the user will funneled to the feature. If the user's context falls above the set rollout percentage, `get_feature()` returns false.
```Ruby
# creating the basic SSE connection
sdk_connection = sdk_client.connect().with_wait_for_data()

# pass in a string to identify an individual user e.g. cookie
sdk_with_context = sdk_connection.with_context('2u43487328')

# the context will generate a percent
# if that percentage falls within that of the rollout
# the feature will evaluate to true, otherwise false
sdk_with_context.get_feature('test this flag')
# -> true

# with a different user identifier that creates a different percentage
sdk_with_context = sdk_connection.with_context('448shIhn2i')
sdk_with_context.get_feature('test this flag')
# -> false
```

## Integrating with Google Analytics

You can set up an integration with Google Analytics by providing an object with your GA tracking ID and a unique client id to `add_google_analytics_collector()`. This tracking ID should begin with `UA-`. The unique client id is used to distinguish the logs on the Analytics platform, so you can decide what identifier you would like to integrate based on your needs.

You can then log an analytics event any time you wish using `log_event()`. This method takes one argument, an `event_object` that must have the following:
- category
- action
- label
- value

```Ruby
config_object = {
	tracking_id: 'UA-###',
	client_id: 'unique id for test'
}

sdk_with_user.add_google_analytics_collector(config_object)

event_object = {
	category: 'test',
	action: 'some action',
	label: 'new label',
	value: '1234'
}
sdk_with_user.log_event(event_object)
```

## Testing 
To run a basic suite of unit tests, just `rake` from the main directory.
