class CreateXbrls < ActiveRecord::Migration
  def change
    create_table :xbrls do |t|
    	t.integer :cik, null: :false, references: :subs
    	t.string :companyname
    	t.string :formtype
    	t.date :datefiled
    	t.string :filename, unique: true
    end
  end
end
