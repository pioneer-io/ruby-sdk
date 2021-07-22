require 'minitest/autorun'
require_relative '../lib/ruby_sdk/event_source_client'
require_relative '../lib/ruby_sdk/feature_state'

class EventSourceClientTest < Minitest::Test 
	def test_get_feature_state
		feature_state_object = { 
			title: 'testing',
			value: true
		}
		client = Minitest::Mock.new 	
		client.expect :get_feature_state, FeatureState.new(feature_state_object)

		EventSourceClient.stub :new, client do
			new_client = EventSourceClient.new
			feature_state = new_client.get_feature_state
			refute(feature_state.nil?)
			assert(feature_state.value)
		end
	end
end