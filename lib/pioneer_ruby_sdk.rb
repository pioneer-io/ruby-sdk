require_relative 'event_source_client'
require_relative 'context'
require_relative 'client_with_context'

class Pioneer_Ruby_Sdk
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

	def with_wait_for_data(time_out = 1, polling_attempts = 5)
		attempts = 0

		until @client.has_data() do
			attempts += 1
			if attempts > polling_attempts
				puts "Cannot connect to Scout, connection timed out"
				break
			end

			sleep(time_out)
		end
		return self
	end

	def with_context(user_key)
		user_key = user_key
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

sdk_client = Pioneer_Ruby_Sdk.new('http://localhost:3030/features', 'a14dcd5b-fcdc-49eb-9cee-2d84dac21d9c')
puts sdk_client
sdk_connection = sdk_client.connect.with_wait_for_data
# p sdk_connection
puts sdk_connection.get_feature('test this flag', true)