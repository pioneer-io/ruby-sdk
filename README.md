# README

This module is a server-side SDK for applications written in Ruby, who are using Pioneer's feature management service.

Visit the Pioneer-io/Pioneer repo for more.

## Getting Started
The Pioneer Ruby SDK is available as a Ruby Gem: https://rubygems.org/gems/pioneer_ruby_sdk

First you need to install the Gem:
```
gem install pioneer_ruby_sdk
```

## Utilising the SDK in application code
Now, you will need to require the `pioneer_ruby_sdk` gem in your application.
To create a new SDK client, the URI of the `scout` daemon is required in addition to an SDK key, obtained from the `Account` tab of the `pioneer` webpage. The default port for `scout` is `:3030` and the `/features` endpoint is the proper endpoint to receive flag updates.

The SDK client will receive ruleset updates in real-time via SSE any time a feature flag is created/updated/deleted via the Pioneer dashboard.
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

### Using the percentage rollout strategy
To create an SDK connection that identifies individual users (required to utilise the percentage rollout strategy):
```Ruby
# Connects to scout and waits until `scout` returns data; if initial connection attempt fails, up to 10 reconnection attempts will be made
sdk_connection = sdk_client.connect().with_wait_for_data()

# pass in a string to identify an individual user e.g. cookie
sdk_with_user = sdk_connection.with_context('2u43487328')

# call `get_feature` method to return status of specific flag
puts sdk_with_user.get_feature('test this flag', true)

# # a basic branch to use a microservice might look like this:
puts 'What service is being called with `test this flag`?'
if sdk_with_user.get_feature('test this flag', true)
	puts 'Calling some microservice...'
	# call to new microservice goes here
else
	puts 'Calling the monolith service...'
	# monolith defined service call goes here
end
```

### Without the percentage rollout strategy
This approach means all receive the feature flag evaluation:
```Ruby
require 'pioneer_ruby_sdk'

sdk_client = PioneerRubySdk.new('/path/to/scout', 'sdk_key')

# Connects to scout and waits until `scout` returns data; if initial connection attempt fails, up to 5 reconnection attempts will be made
sdk_connection = sdk_client.connect().with_wait_for_data()

# call `get_feature` method to return status of specific flag
puts sdk_connection.get_feature('flag name', true)

# # a basic branch to use a microservice might look like this:
puts 'What service is being called with `test this flag`?'
if sdk_connection.get_feature('test this flag', true)
	puts 'Calling some microservice...'
	# call to new microservice goes here
else
	puts 'Calling the monolith service...'
	# monolith defined service call goes here
end
```