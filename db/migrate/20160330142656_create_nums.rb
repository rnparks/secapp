class CreateNums < ActiveRecord::Migration
  def change
    create_table :nums, id: false do |t|
      t.string :adsh, null: false, references: :subs
      t.string :tag
      t.string :v
      t.date :dd
      t.integer :qtrs
      t.string :uom
      t.string :cr
      t.decimal :value
      t.string :footnote
    end
  end
end
