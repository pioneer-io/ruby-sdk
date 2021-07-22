require 'minitest/autorun'
require_relative '../lib/ruby_sdk/mod/handle_undefined_feature'

class HandleUndefinedFeatureTest < Minitest::Test 
	def test_handle_undefined_feature
		key = 'sample key'
		default_value = 'not nil'
		expected_output = "Warning: Could not get '#{key}' from features, using provided default value!"

		assert_output(expected_output) { HandleUndefinedFeature.handle(key, default_value) }
	end
end