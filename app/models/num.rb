class Num < ActiveRecord::Base
	belongs_to :sub
	def value_in_shares?
		return self.uom.include? "shares"
	end
end