# README

Ruby SDK that can be used to create a connection between an application and the `scout` daemon.

## Installation
SDK is available as a Ruby Gem: https://rubygems.org/gems/pioneer_ruby_sdk

To install the Gem:
```
gem install pioneer_ruby_sdk
```

## Utilising the SDK in application code
To create a new SDK client, the URI of the `scout` daemon is required in addition to an SDK key, obtained from the `Account` tab of the `pioneer` webpage.

### Using the percentage rollout strategy
To create an SDK connection that identifies individual users (required to utilise the percentage rollout strategy):
```Ruby
require 'pioneer_ruby_sdk'

sdk_client = Pioneer_Ruby_Sdk.new('/path/to/scout', 'sdk_key')

# Connects to scout and waits until `scout` returns data; if initial connection attempt fails, up to 5 reconnection attempts will be made
sdk_connection = sdk_client.connect().with_wait_for_data()

# pass in a string to identify an individual user e.g. cookie
sdk_with_user = sdk_connection.with_context('2u43487328')

# call `get_feature` method to return status of specific flag
puts sdk_with_user.get_feature("flag name")
```

### Without the percentage rollout strategy
This approach means all receive the feature flag evaluation:
```Ruby
require 'pioneer_ruby_sdk'

sdk_client = Pioneer_Ruby_Sdk.new('/path/to/scout', 'sdk_key')

# Connects to scout and waits until `scout` returns data; if initial connection attempt fails, up to 5 reconnection attempts will be made
sdk_connection = sdk_client.connect().with_wait_for_data()

# call `get_feature` method to return status of specific flag
puts sdk_connection.get_feature("flag name)
```