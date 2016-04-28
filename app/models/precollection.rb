class Precollection < ActiveRecord::Base
	def self.get_nums(collection)
		array = []
		collection.each {|pre| array.push pre.get_nums}
		array.flatten
	end
  def self.formatRows(collection, periods)
		array = Array.new(periods.size)
			collection.each do |num|
				dd = num.dd.to_s
				if array[periods.index(dd)]
					array[periods.index(dd)].push(num)
				else
					array[periods.index(dd)] = [num]
				end
			end
		array
	end
end
