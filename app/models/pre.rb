class Pre < ActiveRecord::Base
	validates :adsh, uniqueness: {scope: [:report, :line] }
end
