class Tag < ActiveRecord::Base
	validates_uniqueness_of :version, :scope => :tag
end
