require 'minitest/autorun'
require_relative '../lib/ruby_sdk/mod/handle_undefined_feature'

class HandleUndefinedFeatureTest < Minitest::Test 
	def test_handle_undefined_feature_with_non_nil_default
		key = 'sample key'
		default_value = 'not nil'
		expected_output = "Warning: Could not get '#{key}' from features, using provided default value!\n"

		assert_equal('not nil', HandleUndefinedFeature.handle(key, default_value))
		assert_output(expected_output) { HandleUndefinedFeature.handle(key, default_value) }
	end

	def test_handle_undefined_feature_with_nil_default
		key = 'sample key'
		default_value = nil

		assert_raises(StandardError) { HandleUndefinedFeature.handle(key, default_value) }
	end
end