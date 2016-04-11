class CreateNums < ActiveRecord::Migration
  def change
    create_table :nums do |t|
      t.belongs_to :subs, index: true
      t.string :adsh, null: false
      t.string :tag
      t.string :version
      t.date :ddate
      t.integer :qtrs
      t.string :uom
      t.integer :coreg
      t.decimal :value
      t.string :footnote
      t.timestamps null: false
    end
  end
end
