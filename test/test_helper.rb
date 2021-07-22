require_relative '../lib/ruby_sdk/strategy'
require_relative '../lib/ruby_sdk/feature_state'

feature_state_object = 
class FakeClient 
	def initialize(flag_value)
		@config = {
			server_address: 'server_address',
			sdk_key: 'some key'
		}
		@features = {
			'testing' => FeatureState.new({
			title: 'testing',
			value: flag_value,
			strategy: { percentage: 50}
			})
		}
		@has_data = true
	end

	def get_feature_state(key)
		return @features[key]
	end
end