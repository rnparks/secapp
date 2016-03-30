class Sub < ActiveRecord::Base
	self.primary_key = 'adsh'
	has_many :nums
end
