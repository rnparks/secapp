class Pre < ActiveRecord::Base
	validates :adsh, uniqueness: {scope: [:report, :line] }
	has_one :v_num, :class_name => 'Num', :foreign_key => 'v', :primary_key => 'v'
	has_one :adsh_num, :class_name => 'Num', :foreign_key => 'adsh', :primary_key => 'adsh'

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
end
