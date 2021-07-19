require_relative 'lib/handle_undefined_feature.rb'

class Client_With_Context
	def initialize(context_obj)
		@context = context_obj[:context]
		@client = context_obj[:client]
		@config = context_obj[:config]
	end

	def get_feature(key, default_value)
		feature_state = @client.get_feature_state(key)
		if !feature_state
			return handle_undefined_feature(key, default_value)
		end

		return feature_state.strategy.calculate(@context)
	end
end