require_relative 'event_source_client'
require_relative 'context'
require_relative 'client_with_context'

class Config 
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
		@client.start()
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
end

test = Config.new('fdhfakjhdsak', 'fdsfs')
puts test.connect().with_context('fdsfsd')