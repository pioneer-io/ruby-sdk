require 'ld-eventsource'
require 'json'
require_relative 'feature_state'

# class for event source client instance
class EventSourceClient 
	def initialize(config)
		@config = config
		@features = {}
		@has_data = false
		options = {
      headers: { Authorization: @config[:sdk_key]}
    }

	sse_client = SSE::Client.new("http://hostname/resource/path", headers: options[:headers])

	@api_client = sse_client
	end

	def start
		handleEvents()
		handleErrors()
	end

	def handleEvents
		@api_client.on_event do |event| 
			data = JSON.parse(event[:data]) 
			event_type = data[:type]
			payload = data[:data]
		end

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
			# this feature is not defined, we need to create/import it
			# return handle_undefined_feature(key, default_value)
			puts "handle undefined feature method call"
			return
		end

		value = feature_state[:value]
		return value
	end


	def get_feature_state(key) 
		return @features[:key]
	end
end

fake_config = { sdk_key: "asdfasdf" }
p fake_config[:sdk_key]
test_client = EventSourceClient.new(fake_config)
# p test_client
puts test_client.get_feature("nokey", 'blah')
