class Num < ActiveRecord::Base
	belongs_to :sub
	validates :adsh, uniqueness: {scope: [:tag, :version, :ddate, :qtrs, :uom, :coreg] }
	def value_in_shares?
		return self.uom.include? "shares"
	end
end