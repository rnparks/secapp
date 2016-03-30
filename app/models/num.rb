class Num < ActiveRecord::Base
	belongs_to :sub
	keys = ["adsh","tag","version","coreg","ddate","qtrs","uom","value","footnote"]
end
