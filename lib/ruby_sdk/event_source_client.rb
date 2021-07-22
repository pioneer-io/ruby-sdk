require 'ld-eventsource'
require 'json'
require_relative 'feature_state'
require_relative 'analytics_collector'
require_relative 'mod/handle_undefined_feature'

# class for event source client instance
class Event_Source_Client 
	attr_reader :has_data

	def initialize(config)
		@config = config
		@features = {}
		@analytics_collectors = []
		@has_data = false
		options = {
      headers: { Authorization: @config[:sdk_key]}
    }

	# this needs to make use of the constant based uri, not hardcoded
	sse_client = SSE::Client.new(@config[:server_address], headers: options[:headers])

	@api_client = sse_client
	end

	def start
		handle_events()
		handle_errors()
	end

	def handle_events
		@api_client.on_event do |event| 
			data = JSON.parse(event[:data]) 
			event_type = data['eventType']
			if event_type == "ALL_FEATURES"
				payload = data['payload']
				handle_all_features(payload)
			end
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
				title: feature['title'],
				value: feature['is_active'],
				strategy: {percentage: feature['rollout']}
			}
			feature_states[feature['title']] = FeatureState.new(modified_feature_state_params)
		end

		@features = feature_states
		@has_data = true
	end

	def get_feature(key, default_value = nil)
		feature_state = get_feature_state(key)
		if feature_state.nil?
			HandleUndefinedFeature.handle(key, default_value)
			return
		end

		feature_state.value
	end


	def get_feature_state(key) 
		return @features[key]
	end

	def add_google_analytics_collector(config_object)
		analytics_collector = AnalyticsCollector.new(config_object)
		@analytics_collectors.push(analytics_collector)
		return analytics_collector
	end

	def log_event(event_object)
		@analytics_collectors.each do |analytics_collector|
			analytics_collector.log_event(event_object)
		end
	end
end
