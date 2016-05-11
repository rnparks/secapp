class AddIdToNums < ActiveRecord::Migration
	def change
		add_index :tags, [:v, :tag], :unique => true
		add_index :pres, [:adsh, :report, :line], :unique => true
	end
end
