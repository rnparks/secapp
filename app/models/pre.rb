class Pre < ActiveRecord::Base
	has_one :sub, :foreign_key => 'adsh', :primary_key => 'adsh'
	has_one :filer, through: :subs
	validates :adsh, uniqueness: {scope: [:report, :line] }

	def get_nums
		Num.find_by_sql("Select * FROM nums WHERE adsh = '#{self.adsh}' AND v = '#{self.v}' AND tag = '#{self.tag}'").select { |nums| nums.dd.year > 2013 }
	end

	def get_tags
		Tag.find_by_sql("Select * FROM tags WHERE tag = '#{self.tag}' AND v = '#{self.v}'")
	end

	def get_tag_attr(attr)
		Tag.find_by_sql("Select #{attr} FROM tags WHERE tag = '#{self.tag}' AND v = '#{self.v}'").first[attr.to_sym]
	end

	def get_num_attr(attr)
		Num.find_by_sql("Select #{attr} FROM nums WHERE tag = '#{self.tag}' AND v = '#{self.v}' AND adsh = '#{self.adsh}'").select { |nums| nums.dd.year > 2013 }
	end

	def self.to_csv
    attributes = %w{id email name}
    CSV.generate(headers: true) do |csv|
      csv << attributes

      all.each do |user|
        csv << attributes.map{ |attr| user.send(attr) }
      end
    end
  end
end
