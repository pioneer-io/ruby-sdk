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

	def get_feature(key, default_value = nil)
		@client.get_feature(key, default_value)
	end
end
