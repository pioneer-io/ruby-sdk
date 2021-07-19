require 'ld-eventsource'
require 'json'
require_relative 'feature_state'
require_relative 'helper_methods/handle_undefined_feature'

# class for event source client instance
class Event_Source_Client 
	attr_reader :has_data

	def initialize(config)
		@config = config
		@features = {}
		@has_data = false
		options = {
      headers: { Authorization: @config[:sdk_key]}
    }

	sse_client = SSE::Client.new("localhost:3030/features", headers: options[:headers])

	@api_client = sse_client
	end

	def start
		handle_events()
		handle_errors()
	end

	def handle_events
		event_type = nil

		@api_client.on_event do |event| 
			data = JSON.parse(event[:data]) 
			event_type = data[:type]
			payload = data[:data]
		end

		puts event_type
		case event_type
		when "ALL_FEATURES" 
			handle_all_features(payload)
		when "CREATE_CONNECTION"
			return
		end
	end

	def handle_errors()
		@api_client.on_error do |error|
			puts "Event Source Failed: ", error
		end
	end


	def handle_all_features(all_features)
		all_features = JSON.parse(all_features)
		feature_states = {}

		all_features.each do |feature|
			modified_feature_state_params = {
				title: feature[:title],
				value: feature[:is_active],
				strategy: {percentage: feature[:rollout]}
			}
			feature_states[feature[:title]] = FeatureState.new(modified_feature_state_params)
		end

		@features = feature_states
		@has_data = true
	end

	def get_feature(key, default_value) 
		feature_state = get_feature_state(key)
		if !feature_state
			handle_undefined_feature(key, default_value)
			return
		end

		value = feature_state[:value]
		return value
	end


	def get_feature_state(key) 
		return @features[:key]
	end
end
