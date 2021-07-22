require 'minitest/autorun'
require_relative '../lib/ruby_sdk/client_with_context'
require_relative '../lib/ruby_sdk/context'
require_relative './test_helper'

class ClientWithContextTest < Minitest::Test
	def test_get_feature_no_default_returns_rollout_true
		context_obj = {
			context: Context.new('1'),
			client: FakeClient.new(true),
			config: 'some configs'
		}
		client_with_context = ClientWithContext.new(context_obj)
		assert(client_with_context.get_feature('testing'))
	end

	def test_get_feature_no_default_no_key_match_raises_error
		context_obj = {
			context: Context.new('1'),
			client: FakeClient.new(true),
			config: 'some configs'
		}
		client_with_context = ClientWithContext.new(context_obj)
		assert_raises(StandardError){client_with_context.get_feature('nope')}
	end
	
	def test_get_feature_with_default_no_key_match_returns_default
		context_obj = {
			context: Context.new('1'),
			client: FakeClient.new(true),
			config: 'some configs'
		}
		client_with_context = ClientWithContext.new(context_obj)
		assert(client_with_context.get_feature('nope', true))
	end
end