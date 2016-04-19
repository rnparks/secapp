class Tag < ActiveRecord::Base
	validates_uniqueness_of :v, :scope => :tag
end
