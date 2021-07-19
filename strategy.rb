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

#   // just adds up all the charCodes in the string and calculate the percentage
#   getHashBasedPercentage(string) {
#     const charArr = string.split('');
#     const sum = charArr.reduce((sum, char) => {
#       return sum + char.charCodeAt();
#     }, 0);
#     const hashedPercentage = ((sum % Strategy.modulus) + 1) / Strategy.modulus;
#     return hashedPercentage;
#   }
# }