class Precollection < ActiveRecord::Base
  def self.formatRows(collection, periods)
		array = Array.new(periods.size)
		collection.each do |pre|
			pre.get_num_attr("dd, adsh, value, uom, tag, v").each do |num|
				if array[periods.index(num.dd)]
					array[periods.index(num.dd)].push(num)
				else
					array[periods.index(num.dd)] = [num]
				end
			end
		end
		array
	end
end
