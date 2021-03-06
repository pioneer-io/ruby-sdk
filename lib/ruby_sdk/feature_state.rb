require_relative 'strategy'

class FeatureState
	attr_reader :value, :strategy
	def initialize(feature_state_object)
		@title = feature_state_object[:title],
		@value = feature_state_object[:value],
		if feature_state_object[:strategy]
			@strategy = Strategy.new(feature_state_object[:strategy][:percentage])
		end
	end
end
