require_relative 'mod/handle_undefined_feature.rb'

class ClientWithContext
	def initialize(context_obj)
		@context = context_obj[:context]
		@client = context_obj[:client]
		@config = context_obj[:config]
	end

	def get_feature(key, default_value = nil)
		feature_state = @client.get_feature_state(key)
		return HandleUndefinedFeature.handle(key, default_value) if !feature_state

		# if value of flag is true, use rollout
		if feature_state.value
			return feature_state.strategy.calculate(@context)
		else
			return feature_state.value
		end
	end

	def add_google_analytics_collector(config_object)
		@client.add_google_analytics_collector(config_object)	
	end

	def log_event(event_object)
		@client.log_event(event_object)
	end
end