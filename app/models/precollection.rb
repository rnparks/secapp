class Precollection < ActiveRecord::Base
	def self.get_nums(collection)
		array = []
		collection.each {|pre| array.push pre.get_nums}
		array.flatten
	end

  def self.format_rows(collection, periods)
		array = Array.new(periods.size)
			collection.each do |num|
				dd = num.dd.strftime("%m/%y")
				if periods.index(dd)
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
