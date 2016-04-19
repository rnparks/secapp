class CreatePres < ActiveRecord::Migration
  def change
    create_table :pres do |t|
      t.string :adsh, null: false, references: :subs
      t.integer :report, null: false
      t.integer :line, null: false
      t.string :stmt
      t.boolean :inpth
      t.string :rfile
      t.string :tag
      t.string :v
      t.string :plabel
    end
  end
end
