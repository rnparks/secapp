class Sub < ActiveRecord::Base
	self.primary_key = 'adsh'
	has_many :nums
	validates_uniqueness_of :adsh
end
