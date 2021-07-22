require 'minitest/autorun'
require_relative '../lib/ruby_sdk/feature_state'

class FeatureStateTest < Minitest::Test
	def test_initialize_method_without_context_creates_title_and_value_only
		feature_state_object = {
			title: 'testing title',
			value: true
		}
		new_feature_state = FeatureState.new(feature_state_object)
		assert(new_feature_state.value)
		assert_equal(true, new_feature_state.value)
		refute(new_feature_state.strategy)
	end

	def test_initialize_method_with_context_creates_title_value_and_strategy
		feature_state_object = {
			title: 'testing title',
			value: true,
			strategy: {
				percentage: 50
			}
		}
		new_feature_state = FeatureState.new(feature_state_object)
		assert(new_feature_state.value)
		assert(new_feature_state.strategy)
		assert_equal(true, new_feature_state.value)
		assert_instance_of(Strategy, new_feature_state.strategy)
	end
end
