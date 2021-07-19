class Strategy
  def initialize(percentage)
		@percentage = percentage
		@modulus = 100
	end


	def calculate(context)
		key = context.get_key()
		hashed_percentage = get_hash_based_percentage(key)
		return hashed_percentage <= @percentage
	end

	def get_hash_based_percentage(string) 
		sum = string.bytes.sum()
		return  ((sum % @modulus) + 1) / @modulus
	end
end
