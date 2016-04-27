class Precollection < ActiveRecord::Base
  def self.formatRows(collection, periods)
		array = Array.new(periods.size)
		collection.each do |pre|
			# pre.get_nums.each do |num|
			pre.get_num_attr("dd, adsh, value, uom, tag, v, qtrs").each do |num|
				dd = num.dd.to_s
				if array[periods.index(dd)]
					array[periods.index(dd)].push(num)
				else
					array[periods.index(dd)] = [num]
				end
			end
		end
		array
	end
end
