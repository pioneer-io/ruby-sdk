class Context
	def initialize(user_key)
		@user_key = user_key
	end

	def get_key()
		return @user_key
	end
end