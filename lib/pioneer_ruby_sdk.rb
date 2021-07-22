require_relative 'ruby_sdk/event_source_client'
require_relative 'ruby_sdk/context'
require_relative 'ruby_sdk/client_with_context'

# wrapper for event source client
class PioneerRubySdk
	def initialize(server_address, sdk_key)
		@server_address = server_address
		@sdk_key = sdk_key
		@configs = {
			server_address: @server_address,
			sdk_key: @sdk_key
		}
	end

	def connect()
		@client = Event_Source_Client.new(@configs)
		@client.start
		self
	end

	def with_wait_for_data()
		time_out = 1
		polling_attempts = 10
		attempts = 0

		until @client.has_data() do
			attempts += 1
			if attempts > polling_attempts
				puts "Cannot connect to Scout, connection timed out"
				break
			end

			puts 'Attempting to connect to scout daemon...'
			sleep(time_out * rand(10))
		end
		return self
	end

	def with_context(user_key)
		context_obj = {
			context: Context.new(user_key),
			client: @client,
			config: @configs
		}

		return Client_With_Context.new(context_obj)
	end

	def get_server_address()
		return @server_address
	end

	def get_feature(key, default_value)
		@client.get_feature(key, default_value)
	end
end

# next, we need to create an instance of the sdk with which we will establish a connection to scout
sdk_client = PioneerRubySdk.new('http://localhost:3030/features', 'a14dcd5b-fcdc-49eb-9cee-2d84dac21d9c')

# connect to scout and wait until `scout` returns data; 
# if initial connection attempt fails, up to 5 reconnection attempts will be made
sdk_connection = sdk_client.connect.with_wait_for_data

puts sdk_connection
# this example assumes that you have an existing flag
# called 'test this flag' that is toggled off

# call `get_feature` method to return status of specific flag
puts 'What is the current state of `test this flag`?'
puts sdk_connection.get_feature('test this flag', true) # should log `false`

# # a basic branch to use a microservice might look like this:
puts 'What service is being called with `test this flag`?'
if sdk_connection.get_feature('test this flag', true)
	puts 'Calling some microservice...'
	# call to new microservice goes here
else
	puts 'Calling the monolith service...'
	# monolith defined service call goes here
end

# pass in a string to identify an individual user e.g. cookie
sdk_with_user = sdk_connection.with_context('90')
config_object = {
	tracking_id: 'UA-202935786-1',
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
if sdk_with_user.get_feature('test this flag', true)
	puts 'Calling some microservice...'
	# call to new microservice goes here
else
	puts 'Calling the monolith service...'
	# monolith defined service call goes here
end