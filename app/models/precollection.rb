class Precollection < ActiveRecord::Base
  def self.formatRows(collection, periods)
		array = Array.new(periods.size)
		collection.each do |pre|
			pre.get_nums.each do |num|
				array[periods.index(num.dd)] = num
			end
		end
		array
	end
end
