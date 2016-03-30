class CreateNums < ActiveRecord::Migration
  def change
    create_table :nums do |t|
      t.string :adsh, :null => :false
      t.string :tag, :null => :false
      t.string :version, :null => :false
      t.date :ddate, :null => :false
      t.integer :qtrs, :null => :false
      t.string :uom, :null => :false
      t.integer :coreg
      t.decimal :value
      t.string :footnote 

      t.timestamps null: false
    end
    add_index :nums, :adsh
  end
end
