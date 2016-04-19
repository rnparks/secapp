class CreateNums < ActiveRecord::Migration
  def change
    create_table :nums do |t|
      t.string :adsh, null: false, references: :subs
      t.string :tag
      t.string :version
      t.date :ddate
      t.integer :qtrs
      t.string :uom
      t.string :coreg
      t.decimal :value
      t.string :footnote
    end
  end
  add_index :nums, [:adsh, :tag, :version, :ddate, :qtrs, :uom, :coreg], :unique => true
end
