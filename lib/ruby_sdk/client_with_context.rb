require_relative 'mod/handle_undefined_feature.rb'

class Client_With_Context
	def initialize(context_obj)
		@context = context_obj[:context]
		@client = context_obj[:client]
		@config = context_obj[:config]
	end

	def get_feature(key, default_value)
		feature_state = @client.get_feature_state(key)
		if !feature_state
			return HandleUndefinedFeature.handle(key, default_value)
		end

		return feature_state.strategy.calculate(@context)
	end

	def add_google_analytics_collector(config_object)
		@client.add_google_analytics_collector(config_object)	
	end

	def log_event(event_object)
		@client.log_event(event_object)
	end
end