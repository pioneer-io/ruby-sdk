require 'minitest/autorun'
require_relative '../lib/ruby_sdk/strategy'
require_relative '../lib/ruby_sdk/context'

class StrategyTest < Minitest::Test
	def test_initialize_new_strategy_returns_strategy
		percentage = 50
		assert_instance_of(Strategy, Strategy.new(percentage))
	end

	def test_new_strategy_get_hash_based_percentage_returns_int_between_0_100
		percentage = 50
		unique_id = 'testinghash'
		new_strategy = Strategy.new(percentage)
		hashed_percentage = new_strategy.get_hash_based_percentage(unique_id)
		assert((1...100).include?(hashed_percentage))
	end

	def test_new_strategy_calculate
		context = Context.new('1')	
		assert_equal('1', context.get_key())

		percentage = 50
		# ascii code point value of '1' is 49, should fall under given percent
		new_strategy = Strategy.new(percentage)
		assert(new_strategy.calculate(context))
	end
end