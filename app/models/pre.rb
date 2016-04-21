class Pre < ActiveRecord::Base
	has_one :sub, :foreign_key => 'adsh', :primary_key => 'adsh'
	has_one :filer, through: :subs
	validates :adsh, uniqueness: {scope: [:report, :line] }

	def get_nums
		Num.find_by_sql("Select * FROM nums WHERE adsh = '#{self.adsh}' AND v = '#{self.v}' AND tag = '#{self.tag}'")
	end

	def get_tags
		Tag.find_by_sql("Select * FROM tags WHERE tag = '#{self.tag}' AND v = '#{self.v}'")
	end

	def get_tag_attr(attr)
		Tag.find_by_sql("Select #{attr} FROM tags WHERE tag = '#{self.tag}' AND v = '#{self.v}'").first[attr.to_sym]
	end

	def get_num_attr(attr)
		Tag.find_by_sql("Select #{attr} FROM nums WHERE tag = '#{self.tag}' AND v = '#{self.v}'")
	end

	def prepare_table_data

	end

	def formatRows(periods)
		array = Array.new(periods.size)
		self.get_nums.each do |num|
			array[periods.index(num.dd)] = num
		end
		array
	end

end
