class Precollection < ActiveRecord::Base
	def self.get_nums(collection)
		array = []
		collection.each {|pre| array.push pre.get_nums}
		array.flatten.uniq { |p| p.value }
	end

  def self.format_rows(collection, periods, form)
		array = Array.new(periods[form].size)
		collection.each do |num|
			dd = num.dd.strftime("%m/%y")
			if periods[form].index(dd)
				if array[periods[form].index(dd)]
					array[periods[form].index(dd)].push(num)
				else
					array[periods[form].index(dd)] = [num]
				end
			form == "10-Q" ? array[periods[form].index(dd)] = array[periods[form].index(dd)].reject { |num| num.qtrs > 1 } : array[periods[form].index(dd)] = array[periods[form].index(dd)].reject { |num| num.qtrs == 1 } if array[periods[form].index(dd)]
			end
		end
		array
	end
end
