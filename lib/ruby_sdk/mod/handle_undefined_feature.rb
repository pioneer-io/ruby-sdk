module HandleUndefinedFeature
	def self.handle(key, default_value)
		unless default_value.nil?
			puts("Warning: Could not get #{key} from features, using provided default value!")
			return default_value
		end
		raise("Error: #{key} does not exist, cannot get get feature!");
	end
end
