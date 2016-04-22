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

end

class HtmlParserIncluded < HTTParty::Parser
  def html
    Nokogiri::HTML(body)
  end
end

class Page
  include HTTParty
  parser HtmlParserIncluded
end

